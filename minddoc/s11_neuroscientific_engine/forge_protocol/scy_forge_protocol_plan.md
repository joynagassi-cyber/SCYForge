<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-FORGE-PROTOCOL — PLAN (PLAN)
**ID** : S11_NEURO_FORGE_PROTOCOL_PLAN · **Décision** : D-OPT-014

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## Flux
```
[Utilisateur demande à voir un contenu éducatif (Knowledge Card / cours)]
   │
   ▼
[Génération challenge Feynman à trous (NEURON-CHAINS, concept clé du nœud)]
   │
   ▼
[Amorce exigée AVANT affichage (interdit affichage passif, D-OPT-014)]
   │
   ├── Réussite ──► Affichage contenu + mesure rétention (APEX FSRS)
   │
   └── Échec (×2 consécutif sur nœud difficile)
        │
        ▼
   [Affichage aide instantanée ELI5 (D-OPT-024) → neutralise frustration]
        │
        ▼
   [Accès au contenu garanti (pas de blocage)]
```
## Dépendances : APEX-AGENT (évaluation), NEURON-CHAINS (challenge), ELI5 fallback (D-OPT-024), APEX FSRS (mesure rétention).
## Fichiers : `backend_rs/src/neuro/forge/forge_challenge.rs`, `forge_evaluator.rs`.
