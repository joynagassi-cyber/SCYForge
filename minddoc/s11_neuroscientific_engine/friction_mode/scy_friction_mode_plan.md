<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-FRICTION-MODE — PLAN (PLAN)
**ID** : S11_NEURO_FRICTION_MODE_PLAN · **Décisions** : D-OPT-015, D-OPT-049

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
[Session APEX active — Mode FRICTION activé]
   │
   ▼
[ADAPTIVE-ROUTER (AGENT-06, Rust déterministe) : entrelacement 70% domaine cible / 30% connexes maîtres (D-OPT-049)]
   │
   ▼
[Désactivation barres de progression UI pendant session active (D-OPT-015)]
   │
   ▼
[Casse de l'habituation cognitive du cortex visuel → ×2 rétention long terme]
   │
   ▼
[Mesure rétention APEX FSRS (comparaison fluide vs FRICTION)]
```
## Dépendances : ADAPTIVE-ROUTER (AGENT-06), UI session, APEX FSRS. Fichiers : `backend_rs/src/neuro/friction/interleaver.rs`, `frontend_react/src/apex/FrictionSessionUI.tsx`.
