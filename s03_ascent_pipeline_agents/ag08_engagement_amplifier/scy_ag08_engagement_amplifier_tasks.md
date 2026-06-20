# 📋 SCY-AG08-ENGAGEMENT-AMPLIFIER — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG08_ENGAGEMENT_AMPLIFIER_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche 8.1 : Coder l'Attribution XP + Niveaux (Durée : 25 min)
* **Description** : Coder `xpRules` (XP par type d'événement, paliers de niveaux) et la persistance dans `mfg_user_xp`.
* **Fichier** : `backend_ts/src/ascent/gamification/xp_rules.ts`
* **Critère de Succès** : Un `NodeCompleted` attribue l'XP correcte et met à jour le niveau.

### 🚀 Tâche 8.2 : Coder les Badges + Streaks (Durée : 25 min)
* **Description** : Coder la bibliothèque de badges (conditions de déblocage) et la gestion des streaks (activité quotidienne continue).
* **Fichier** : `backend_ts/src/ascent/gamification/badges.ts`
* **Critère de Succès** : Un accomplissement débloque le badge ; une activité continue maintient le streak.

### 🚀 Tâche 8.3 : Coder les Micro-Objectifs + Notification (Durée : 20 min)
* **Description** : Coder la génération de micro-objectifs sur alerte drift (AGENT-07) et la notification des récompenses via COSMOS/CHRONICLE.
* **Fichier** : `backend_ts/src/ascent/agents/ag08_engagement_amplifier.ts`
* **Critère de Succès** : Une alerte drift propose un micro-objectif récompensé ; les récompenses sont notifiées.
