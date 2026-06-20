# 📋 SCY-AG12-VISUAL-CRITIC — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S03_ASCENT_AG12_VISUAL_CRITIC_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

### 🚀 Tâche 12.1 : Coder les Métriques de Lisibilité (Durée : 25 min)
* **Description** : Coder `readabilityMetrics` (densité nœuds/arêtes, chevauchements, lisibilité labels) avec seuils.
* **Fichier** : `backend_ts/src/ascent/visual/readability_metrics.ts`
* **Critère de Succès** : Un graphe dense est signalé (seuil dépassé).

### 🚀 Tâche 12.2 : Coder la Conformité Design + WCAG (Durée : 20 min)
* **Description** : Coder `designCompliance` (vérification tokens `design.md`, contraste WCAG).
* **Fichier** : `backend_ts/src/ascent/visual/design_compliance.ts`
* **Critère de Succès** : Une couleur hors tokens est rejetée ; un contraste insuffisant est signalé.

### 🚀 Tâche 12.3 : Coder la Validation Sémantique + Recommandations (Durée : 25 min)
* **Description** : Coder la vérification de justesse sémantique (AGENT-13), la production de recommandations concrètes et l'émission des ajustements à COSMOS, validé par `VisualCritiqueSchema`.
* **Fichier** : `backend_ts/src/ascent/agents/ag12_visual_critic.ts`
* **Critère de Succès** : Une arête fausse est détectée ; des recommandations concrètes sont émises.
