<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
COSMOS en MVP réduit à 4 modes. 26 modes originaux différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-ENGINE-NIVO — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S04_COSMOS_ENGINE_NIVO_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

### 🚀 Tâche NV.1 : Coder le Lazy-Loader nivo (Durée : 20 min)
* **Description** : Coder `nivo_loader.ts` avec imports dynamiques des 4 modules nivo (chunks indépendants, hors bundle initial).
* **Fichier** : `frontend_react/src/cosmos/engines/nivo_loader.ts`
* **Critère de Succès** : Les modules sont chargés à la demande ; le bundle initial n'inclut pas nivo.

### 🚀 Tâche NV.2 : Coder Chord M12 + Sankey M13 (Durée : 30 min)
* **Description** : Coder les composants M12 (Chord, matrice ≤ 200) et M13 (Sankey, flux < 2% masqués) avec interactions survol.
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : M12 rend les rubans et met en valeur au survol ; M13 masque les flux mineurs.

### 🚀 Tâche NV.3 : Coder Heatmap M16 + Circle Packing M19 (Durée : 30 min)
* **Description** : Coder M16 (Heatmap, `⚠️` si similarité > 0.95) et M19 (Circle Packing, bulles < 5px masquées).
* **Fichier** : `frontend_react/src/cosmos/modes/`
* **Critère de Succès** : M16 affiche l'alerte de redondance ; M19 masque les sous-bulles trop petites.

### 🚀 Tâche NV.4 : Coder les Limites Tiers + Fallback (Durée : 20 min)
* **Description** : Coder l'application des limites de nœuds (Chord ≤ 150/200) et le fallback liste simplifiée sur LOW/COMPAT.
* **Fichier** : `frontend_react/src/cosmos/engines/nivo_loader.ts`
* **Critère de Succès** : Les limites sont appliquées ; le fallback s'active sur appareil faible.
