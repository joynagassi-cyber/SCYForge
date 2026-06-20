# 🧪 SCY-AG08-ENGAGEMENT-AMPLIFIER — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S03_ASCENT_AG08_ENGAGEMENT_AMPLIFIER_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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
