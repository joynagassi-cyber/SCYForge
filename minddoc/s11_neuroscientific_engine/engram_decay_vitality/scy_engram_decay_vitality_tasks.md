<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-ENGRAM-DECAY-VITALITY — LISTE DE TÂCHES ATOMIQUES (TASKS)
**ID Spécification** : S11_ENGRAM_DECAY_VITALITY_TASKS  
**Statut** : 🟢 SPRINT DE CODAGE PRÊT POUR EXÉCUTION  

Chaque tâche est conçue pour être codée en 15 à 30 minutes de manière unitaire et testable par nos agents de développement.

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

## 🧭 Liste des Tâches de Production

### 🚀 Tâche 1.1 : Coder l'Équation Sigmoïdale en Rust (Durée : 15 min)
* **Description** : Implémenter l'équation de vitalité synaptique $V_n(t)$ calibrée avec protection contre les overflows de calcul dans le moteur de calcul Rust.
* **Fichier de destination** : `backend_rust/src/neuroscientific/engram_decay.rs`
* **Critère de Succès** : Exécuter la fonction avec un grand intervalle temporel ($t = 10^9$) ne lève pas d'overflow ou de NaN et retourne un score stable de `0.0`.

### 🚀 Tâche 1.2 : Coder le Cron de Transition vers la Dormance (Durée : 25 min)
* **Description** : Implémenter le workflow d'archivage TypeScript. Ce code sélectionne les nœuds dont le score $V_n(t) < 20.0$, les déplace vers `scy_engram_vault` tout en nettoyant le graphe actif.
* **Fichier de destination** : `backend_ts/src/normal_pipeline/workflows/engramCron.ts`
* **Critère de Succès** : L'exécution du workflow sur un utilisateur témoin déplace exactement les nœuds sous le seuil et supprime leur visibilité active dans COSMOS.

### 🚀 Tâche 1.3 : Implémenter la Validation de Résurrection Sémantique (Durée : 25 min)
* **Description** : Coder l'endpoint d'évaluation de la tentative de résurrection de l'élève en calculant la similarité cosinus locale par rapport aux connaissances de l'engram.
* **Fichier de destination** : `backend_rust/src/routes/neuroscience_resurrection.rs`
* **Critère de Succès** : Une saisie utilisateur sémantiquement correcte (similarité $\ge 0.70$) réactive le nœud en base avec une vitalité de 50.0.

### 🚀 Tâche 1.4 : Coder le composant UI de Résurrection Socratique (Durée : 20 min)
* **Description** : Créer le composant React d'interface bloquant l'activation directe d'un nœud en dormance et forçant l'élève à soumettre son explication d'effort de génération.
* **Fichier de destination** : `components/ResurrectionProtocolGate.tsx`
* **Critère de Succès** : L'interface affiche correctement les 3 mots-clés d'indices et masque l'accès au nœud tant que le serveur ne valide pas la résurrection.
