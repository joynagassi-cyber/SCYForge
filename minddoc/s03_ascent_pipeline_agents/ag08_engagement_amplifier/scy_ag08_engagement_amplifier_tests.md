<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag08_engagement_amplifier DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-AG08-ENGAGEMENT-AMPLIFIER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG08_ENGAGEMENT_AMPLIFIER_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

---

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

### 🧪 Test 8.1 : Attribution XP (Happy Path)
* **Input** : `NodeCompleted`.
* **Attendu** : XP correcte attribuée ; niveau mis à jour dans `mfg_user_xp`.

### 🧪 Test 8.2 : Déblocage de Badge
* **Pré-conditions** : Accomplissement spécial atteint.
* **Attendu** : Badge débloqué dans `mfg_badges` et notifié.

### 🧪 Test 8.3 : Gestion du Streak
* **Pré-conditions** : Activité quotidienne sur N jours consécutifs.
* **Attendu** : Streak maintenu/augmenté ; rupture d'activité réinitialise le streak.

### 🧪 Test 8.4 : Micro-Objectif de Ré-Engagement
* **Pré-conditions** : Alerte drift (AGENT-07).
* **Attendu** : Micro-objectif proposé et récompensé à l'accomplissement.

### 🧪 Test 8.5 : Aucune Action = Aucune Récompense
* **Attendu** : Sans événement mesuré, aucun XP/badge n'est attribué.
