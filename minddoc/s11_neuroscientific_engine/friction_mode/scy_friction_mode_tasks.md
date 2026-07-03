<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-FRICTION-MODE — TÂCHES (TASKS)
**ID** : S11_NEURO_FRICTION_MODE_TASKS · **Décisions** : D-OPT-015, D-OPT-049

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

### Tâche FM.1 : Coder l'entrelacement 70/30 (20 min)
* **Fichier** : `backend_rs/src/neuro/friction/interleaver.rs`
* **Description** : ADAPTIVE-ROUTER déterministe — 70% domaine cible / 30% connexes maîtres.
* **Critère** : Ratio 70/30 respecté (déterministe, pas aléatoire).

### Tâche FM.2 : Coder la désactivation des barres de progression (15 min)
* **Fichier** : `frontend_react/src/apex/FrictionSessionUI.tsx`
* **Description** : Masquage barres de progression pendant session active.
* **Critère** : Barres masquées en session FRICTION active.

### Tâche FM.3 : Intégrer la mesure de rétention (15 min)
* **Fichier** : `backend_rs/src/neuro/friction/interleaver.rs`
* **Description** : Mesure APEX FSRS (comparaison fluide vs FRICTION).
* **Critère** : Gain de rétention mesurable (×2 objectif).
