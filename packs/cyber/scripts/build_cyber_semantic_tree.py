#!/usr/bin/env python3
"""Génère l'arbre sémantique cyber CANONIQUE (owner_kind=domain_pack).

Source de vérité (corpus réels déjà clonés dans le repo) :
  - packs/cyber/ontology/attack_hierarchy.json  (MITRE CTI STIX : tactiques/techniques/sous-techniques)
  - packs/cyber/ontology/attack_density.json     (SigmaHQ : densité de règles par technique = criticité)

Structure produite (cf. docs/SCYFORGE_SEMANTIC_TREE_INFRASTRUCTURE.md) :
  Trunk   = tactique ATT&CK (kill_chain_order)         -> EdgeKind::Trunk
  Branch  = technique (famille TXXXX)                  -> EdgeKind::Branch
  Leaf    = sous-technique (TXXXX.YYY)                  -> EdgeKind::Leaf

  criticality(branche) = densité Sigma normalisée [0..1]  (80/20 natif)

Sortie : packs/cyber/ontology/cyber_semantic_tree.json
Aucune donnée inventée : tout vient des deux JSON ci-dessus.
"""
import json
import os
import uuid

HERE = os.path.dirname(os.path.abspath(__file__))
ONTO = os.path.normpath(os.path.join(HERE, "..", "ontology"))
HIER_PATH = os.path.join(ONTO, "attack_hierarchy.json")
DENS_PATH = os.path.join(ONTO, "attack_density.json")
OUT_PATH = os.path.join(ONTO, "cyber_semantic_tree.json")

# UUID déterministe (reproductible) via namespace fixe : même entrée -> même id.
NS = uuid.UUID("5c1f0a9e-0000-4000-8000-000000000001")


def did(*parts: str) -> str:
    return str(uuid.uuid5(NS, "|".join(parts)))


def main() -> None:
    with open(HIER_PATH, encoding="utf-8") as f:
        hier = json.load(f)
    with open(DENS_PATH, encoding="utf-8") as f:
        dens = json.load(f)

    kill_chain = hier["kill_chain_order"]
    families = hier["families"]

    # Densité Sigma par technique (clé = id technique, ex T1059.001 ou T1003).
    density = {t["id"]: t["rule_density"] for t in dens["techniques"]}
    max_density = max(density.values()) if density else 1

    def criticality(tech_id: str) -> float:
        # On agrège la densité de la famille + de ses sous-techniques pour la branche.
        score = density.get(tech_id, 0)
        for sub_id in families.get(tech_id, {}).get("sub_techniques", {}):
            score = max(score, density.get(sub_id, 0))
        return round(score / max_density, 4) if max_density else 0.0

    nodes = []          # {id, kind, attack_id, title, tactic, criticality}
    edges = []          # {from_node, to_node, kind, criticality}
    root_nodes = []

    # 1) TRONCS = tactiques (kill_chain_order)
    tactic_node = {}
    for tactic in kill_chain:
        nid = did("trunk", tactic)
        tactic_node[tactic] = nid
        root_nodes.append(nid)
        nodes.append({
            "id": nid,
            "kind": "trunk",
            "attack_id": None,
            "title": tactic.replace("-", " ").title(),
            "tactic": tactic,
            "criticality": 1.0,  # le tronc est la fondation
        })

    # 2) BRANCHES = techniques, rattachées à leur(s) tactique(s)
    for fam_id, fam in families.items():
        crit = criticality(fam_id)
        bnid = did("branch", fam_id)
        nodes.append({
            "id": bnid,
            "kind": "branch",
            "attack_id": fam_id,
            "title": fam["name"],
            "tactic": fam.get("phases", []),
            "criticality": crit,
        })
        for phase in fam.get("phases", []):
            parent = tactic_node.get(phase)
            if parent:
                edges.append({
                    "from_node": parent,
                    "to_node": bnid,
                    "kind": "branch",
                    "criticality": crit,
                })

        # 3) FEUILLES = sous-techniques
        for sub_id, sub_name in fam.get("sub_techniques", {}).items():
            lcrit = round(density.get(sub_id, 0) / max_density, 4) if max_density else 0.0
            lnid = did("leaf", sub_id)
            nodes.append({
                "id": lnid,
                "kind": "leaf",
                "attack_id": sub_id,
                "title": sub_name,
                "tactic": fam.get("phases", []),
                "criticality": lcrit,
            })
            edges.append({
                "from_node": bnid,
                "to_node": lnid,
                "kind": "leaf",
                "criticality": lcrit,
            })

    tree = {
        "id": did("tree", "cyber"),
        "owner_kind": "domain_pack",
        "owner_id": did("owner", "cyber-pack"),
        "domain_pack": "cyber",
        "provenance": {
            "hierarchy": "MITRE CTI STIX enterprise-attack",
            "criticality_source": "SigmaHQ rule density",
            "rules_scanned": dens.get("generated_from", {}).get("rules_scanned"),
            "techniques_total": hier.get("totals", {}).get("techniques"),
            "sub_techniques_total": hier.get("totals", {}).get("sub_techniques"),
        },
        "root_nodes": root_nodes,
        "stats": {
            "trunks": sum(1 for n in nodes if n["kind"] == "trunk"),
            "branches": sum(1 for n in nodes if n["kind"] == "branch"),
            "leaves": sum(1 for n in nodes if n["kind"] == "leaf"),
            "edges": len(edges),
        },
        "nodes": nodes,
        "edges": edges,
    }

    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(tree, f, indent=2, ensure_ascii=False)

    s = tree["stats"]
    print(f"[OK] {OUT_PATH}")
    print(f"     troncs={s['trunks']} branches={s['branches']} "
          f"feuilles={s['leaves']} aretes={s['edges']}")
    top = sorted([n for n in nodes if n["kind"] == "branch"],
                 key=lambda n: n["criticality"], reverse=True)[:5]
    print("     top-5 branches par criticité (densité Sigma):")
    for n in top:
        print(f"       {n['attack_id']:<10} {n['criticality']:.3f}  {n['title']}")


if __name__ == "__main__":
    main()
