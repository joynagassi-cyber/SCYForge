#!/usr/bin/env python3
"""
SCYForge — Pivot Marker Script
Applique un header "pivot-aware" sur tous les fichiers .md du repo.

Usage:
  python pivot_mark.py                    # dry-run
  python pivot_mark.py --apply            # applique
  python pivot_mark.py --apply --backup   # + sauvegarde .bak
"""

import os
import sys
from pathlib import Path

REPO_DIR = Path(__file__).parent.parent
MINDOC_DIR = REPO_DIR / "minddoc"
DOCS_DIR = REPO_DIR / "docs"

# ─── minddoc module classification ────────────────────────────
MODULE_CLASSIFICATION = {
    "s00_prd": ("IN_MVP", "PRD source de vérité — adapter pour cyber beachhead"),
    "s00_design": ("UNCHANGED", "Design tokens et simulators — inchangés"),
    "s00_architecture_standards": ("IN_MVP", "Standards architecturaux — ajouter section beachhead"),
    "s01_ingestion_cores": ("DEFERRED",
        "Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé."),
    "s02_neuron_chains_apex_agent": ("DEFERRED",
        "NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP."),
    "s03_ascent_pipeline_agents": ("IN_MVP",
        "ASCENT en MVP avec Plan C refactor (domain contract consumption). "
        "AGENT-08/10/11/15/16/17/18 différés."),
    "s04_scy_cosmos_visualization_engine": ("IN_MVP",
        "COSMOS en MVP réduit à 4 modes. 26 modes originaux différés."),
    "s05_apex_retention_system": ("IN_MVP",
        "APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé."),
    "s06_scy_brain_rag_assistant": ("IN_MVP",
        "BRAIN en MVP simplifié (BM25 FTS uniquement). Triple retrieval + live web différés."),
    "s07_scy_imprint_cognitive": ("ELIMINATED",
        "IMPRINT ÉLIMINÉE. Contenu biblique incompatible avec cyber ops. Réécriture nécessaire."),
    "s08_scy_reader_suite": ("DEFERRED", "Reader Suite DIFFÉRÉE. Phase 2+."),
    "s09_harmonist_validation_gates": ("IN_MVP", "Harmonist gates GARDÉES. Trust gates intégrité."),
    "s10_normal_mode_ingestion": ("ELIMINATED",
        "Normal Mode ÉLIMINÉE. Beachhead = role-based onboarding."),
    "s11_neuroscientific_engine": ("DEFERRED",
        "Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement."),
    "s12_b2b_creator_console": ("ELIMINATED",
        "B2B Creator Console ÉLIMINÉE. Conservée Enterprise Tier Phase 2."),
    "s13_pivotiq_reconciliation": ("DEFERRED",
        "PIVOTIQ DIFFÉRÉ. Stub uniquement. Utile Phase 2+ multi-domain."),
    "s14_finance_suite": ("ELIMINATED",
        "Finance Suite ÉLIMINÉE. Domaine finance hors scope cyber. Phase 4+."),
}

AGENT_DEFERRED = {
    "ag08_engagement_amplifier", "ag10_chronicle", "ag11_arena",
    "ag15_axiomatizer", "ag16_trunk_validator",
    "ag17_work_mode_detector", "ag18_conscious_agent",
}

# ─── docs/ classification ──────────────────────────────────────
DOCS_CLASSIFICATION = {
    # Already pivot-aware (new docs)
    "SCYFORGE_PIVOT_ARCHITECTURE.md": ("IN_MVP", "Doc pilote pivot architecture."),
    "SCYFORGE_C4_MODEL.md": ("IN_MVP", "C4 model architecture."),
    "SCYFORGE_SEQUENCE_DIAGRAMS.md": ("IN_MVP", "Diagrammes séquence onboarding + pack loader."),
    # Core strategy docs — already cyber-aware from workspace-research
    "SCYFORGE_STRATEGIC_MASTERPLAN.md": ("IN_MVP", "Strategic masterplan consolidé."),
    "SCYFORGE_DOMAIN_PACK_CONTRACT.md": ("IN_MVP", "Contrat d'extensibilité Domain Pack."),
    "SCYFORGE_FEATURE_PATTERNING_ARCHITECTURE.md": ("IN_MVP", "Patterning features cyber."),
    "SCYFORGE_SEMANTIC_TREE_INFRASTRUCTURE.md": ("IN_MVP", "Infrastructure Semantic Tree."),
    "SCYFORGE_13_AGENTS_REFACTOR_PLAN_00_OVERVIEW.md": ("IN_MVP", "Plan C refactor agents."),
    "SCYFORGE_BETH_TRUNK_VALIDATOR.md": ("IN_MVP", "Beth Trunk Validator."),
    "SCYFORGE_BETH_LOGICAL_REPRESENTATION_CYBER.md": ("IN_MVP", "Beth Datalog Horn rules cyber."),
    "SCYFORGE_BETH_ASCENT_AGENT_COUPLING.md": ("IN_MVP", "Beth/ASCENT coupling."),
    "SCYFORGE_RCL_PROTOCOL_SPEC.md": ("IN_MVP", "RCL Protocol spec."),
    "SCYFORGE_RCL_MESSAGE_CATALOG.md": ("IN_MVP", "RCL message catalog."),
    "SCYFORGE_RCL_IMPLEMENTATION_BACKLOG.md": ("IN_MVP", "RCL implementation backlog."),
    "SCYFORGE_COGNITIVE_RUNTIME_POLICIES.md": ("IN_MVP", "Cognitive runtime policies."),
    "SCYFORGE_RECURSIVEMAS_RESEARCH_AND_ADAPTATION.md": ("DEFERRED", "RecursiveMAS différé post-MVP."),
    "SCYFORGE_FEATURE_TO_PROVIDER_MATRIX.md": ("IN_MVP", "Feature-to-Provider Matrix."),
    "SCYFORGE_DOMAIN_CONTRACTS_BLUEPRINT.md": ("IN_MVP", "Domain Contracts Blueprint."),
    "SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_A_CORE.md": ("IN_MVP", "COSMOS plugin infrastructure."),
    "SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_B_CYBER.md": ("IN_MVP", "COSMOS cyber plugin."),
    "SCYFORGE_COSMOS_PLUGIN_INFRASTRUCTURE_C_ARBORIZATION.md": ("IN_MVP", "COSMOS arborization."),
    "SCYFORGE_GENERATIVE_TREE_POLLINATION_SEED.md": ("DEFERRED", "Generative engine différé."),
    "SCYFORGE_GENERATIVE_ENGINE_LOGICAL_MODEL.md": ("DEFERRED", "Generative engine model différé."),
    "SCYFORGE_GENERATIVE_ENGINE_MATH_FORMALIZATION.md": ("DEFERRED", "Beth math formalization différé."),
    "SCYFORGE_GENERATIVE_BETH_STACK_INDEX.md": ("DEFERRED", "Beth stack index différé."),
    "SCYFORGE_COMPETITIVE_LANDSCAPE_CYBER.md": ("IN_MVP", "Competitive landscape."),
    "SCYFORGE_BLUEPRINT_CYBER.md": ("IN_MVP", "Strategic blueprint (consolidé dans masterplan)."),
    "SCYFORGE_MONOPOLY_MAP_CYBER.md": ("IN_MVP", "Monopoly map."),
    "SCYFORGE_WHY_WE_WIN_MEMO.md": ("IN_MVP", "Why we win memo."),
    "SCYFORGE_VALUE_PROPOSITION_CANVAS_CYBER.md": ("IN_MVP", "Value proposition canvas."),
    "SCYFORGE_THIEL_ACTION_MEMO.md": ("IN_MVP", "Thiel action memo."),
    "SCYFORGE_RARE_RESOURCE_MOAT_MAP.md": ("IN_MVP", "Rare resource moat."),
    "SCYFORGE_CYBER_NICHE_MARKET_STUDY.md": ("IN_MVP", "Niche market study."),
    "SCYFORGE_FUNDRAISING_CERT_STRATEGY.md": ("IN_MVP", "Fundraising strategy."),
    "SCYFORGE_SALES_NICHE_MARKET_STUDY.md": ("IN_MVP", "Sales market study."),
    # Unchanged operational docs
    "BUILD_COMMANDS.md": ("UNCHANGED", "Build commands — inchangé."),
    "CODE_STYLE.md": ("UNCHANGED", "Code style — inchangé."),
    "PROJECT_STRUCTURE.md": ("UNCHANGED", "Project structure — inchangé."),
    "DEPENDENCY_MANIFEST.md": ("IN_MVP", "Dependency manifest — à jour pour cyber."),
    "index.md": ("UNCHANGED", "Index — déjà mis à jour manuellement."),
    "AUDIT_STRUCTURE.md": ("UNCHANGED", "Audit structure — inchangé."),
    # Needs manual update
    "IMPLEMENTATION_ORDER.md": ("IN_MVP", "Implémentation order — adapté pour cybe."),
    "AGENT_GUIDE.md": ("UNCHANGED", "Agent guide générique."),
    "ROUTES.md": ("IN_MVP", "Routes — vérifier endpoints cyber."),
    "DATA_MODEL.md": ("IN_MVP", "Data model — ajouter tables cyber."),
    "WORKFLOWS.md": ("IN_MVP", "Workflows — adapter pour SOC roles."),
}

BANNER = "<!--\nBEACHHEAD PIVOT v2.0 — {status}\n{note}\nSource de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md\nDate du pivot : 2026-07-01\n-->\n\n"

SCOPE = """---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | {status} |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

{changes}

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---\n"""


def classify(filepath: Path) -> tuple:
    """Return (status, note) for any .md file in repo."""
    name = filepath.name

    # Check docs/ classification first
    if filepath.is_relative_to(DOCS_DIR):
        if name in DOCS_CLASSIFICATION:
            return DOCS_CLASSIFICATION[name]
        # docs/ files not in classification → mark as IN_MVP (safe default for strategy docs)
        return ("IN_MVP", "Doc stratégie/architecture — vérifier alignement pivot.")

    # minddoc files
    try:
        rel = filepath.relative_to(MINDOC_DIR)
        parts = rel.parts
        module = parts[0] if len(parts) > 1 else ""
    except ValueError:
        return ("UNKNOWN", "Fichier hors minddoc/docs.")

    if module == "s03_ascent_pipeline_agents" and len(parts) > 2:
        if parts[1] in AGENT_DEFERRED:
            return ("DEFERRED", f"Agent {parts[1]} DIFFÉRÉ beachhead MVP.")

    if module in MODULE_CLASSIFICATION:
        return MODULE_CLASSIFICATION[module]
    return ("UNKNOWN", "Module non classifié.")


def process(filepath: Path, apply=False, backup=False):
    try:
        content = filepath.read_text(encoding="utf-8")
    except Exception as e:
        return f"ERROR (read): {filepath.name} — {e}"

    if content.lstrip().startswith(("{", "[")):
        return f"SKIP (json): {filepath.name}"

    status, note = classify(filepath)

    if status == "UNCHANGED":
        return f"SKIP (unchanged): {filepath.relative_to(MINDOC_DIR) if filepath.is_relative_to(MINDOC_DIR) else filepath.name}"

    rel_display = str(filepath.relative_to(REPO_DIR))

    if "BEACHHEAD PIVOT v2.0" in content[:800] and "BEACHHEAD SCOPE" in content:
        return f"SKIP (done): {rel_display}"

    new = content
    acts = []

    if "BEACHHEAD PIVOT v2.0" not in content[:800]:
        new = BANNER.format(status=status, note=note) + new
        acts.append("banner")

    if "BEACHHEAD SCOPE" not in new:
        changes = {
            "IN_MVP": ("• Adapté pour contexte cyber beachhead (SOC/blue-team)\n"
                       "• Personas rebrandés pour opérateurs cyber\n"
                       "• Conserve la mécanique core, change l'instanciation métier"),
            "DEFERRED": ("• **Ce module n'est PAS dans le beachhead MVP**\n"
                         "• La spec est conservée pour référence Phase 2+\n"
                         "• Voir PIVOT_ARCHITECTURE §3"),
            "ELIMINATED": ("• **Ce module est ÉLIMINÉ du beachhead**\n"
                           "• Conservé pour expansion future\n"
                           "• Voir PIVOT_ARCHITECTURE §3"),
        }
        section = SCOPE.format(status=status, changes=changes.get(status, "• À vérifier"))
        lines = new.split("\n")
        idx = 0
        for i, l in enumerate(lines[:25]):
            if l.strip() == "---" and i > 0:
                idx = i + 1
                break
            if l.startswith("# "):
                idx = i + 1
                for j in range(i + 1, min(len(lines), i + 20)):
                    if lines[j].startswith("#"):
                        idx = j
                        break
                break
        lines.insert(idx, section)
        new = "\n".join(lines)
        acts.append("scope")

    if not apply:
        return f"WOULD ({','.join(acts)}): {rel_display}"

    if backup:
        filepath.with_suffix(filepath.suffix + ".bak").write_text(content, encoding="utf-8")
    filepath.write_text(new, encoding="utf-8")
    return f"MARKED ({','.join(acts)}): {rel_display}"


def main():
    dry_run = "--apply" not in sys.argv
    backup = "--backup" in sys.argv
    mode = "DRY-RUN" if dry_run else f"APPLY{'+BACKUP' if backup else ''}"

    md_files = sorted(MINDOC_DIR.rglob("*.md"))

    # Add specific docs/ files to mark
    extra = [
        DOCS_DIR / "SCYFORGE_PIVOT_ARCHITECTURE.md",
        DOCS_DIR / "SCYFORGE_C4_MODEL.md",
        DOCS_DIR / "SCYFORGE_SEQUENCE_DIAGRAMS.md",
        DOCS_DIR / "IMPLEMENTATION_ORDER.md",
        DOCS_DIR / "ROUTES.md",
        DOCS_DIR / "DATA_MODEL.md",
        DOCS_DIR / "WORKFLOWS.md",
    ]
    for ex in extra:
        if ex.exists() and ex.name != "index.md":
            md_files.append(ex)

    seen = set()
    files = []
    for f in md_files:
        key = str(f.resolve())
        if key not in seen and f.name != "index.md":
            seen.add(key)
            files.append(f)

    print(f"SCYForge Pivot Marker — {mode}")
    print(f"Files to process: {len(files)}")
    print("=" * 70)

    stats = {"skip": 0, "would": 0, "written": 0, "err": 0}
    output = []

    for f in files:
        try:
            r = process(f, apply=not dry_run, backup=backup)
        except Exception as e:
            r = f"ERROR: {f.name} — {e}"
            stats["err"] += 1
        output.append(r)
        if "SKIP" in r or "SKIP" in r:
            stats["skip"] += 1
        elif "WOULD" in r:
            stats["would"] += 1
        elif "MARKED" in r:
            stats["written"] += 1

    for line in output:
        print(line)

    print()
    print("=" * 70)
    print(f"STATS: {stats['skip']} skip, {stats['would']} would, "
          f"{stats['written']} written, {stats['err']} errors")

    if dry_run:
        print("\n→ --apply pour écrire, --backup pour .bak")


if __name__ == "__main__":
    main()
