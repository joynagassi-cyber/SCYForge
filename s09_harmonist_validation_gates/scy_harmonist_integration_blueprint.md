# Blueprint d'Intégration Harmonist — SCY Forge v2.5
**Document ID** : BLUEPRINT-MINDFORGE-HARMONIST-INTEGRATION-V1  
**Date** : 2026-06-10  
**Statut** : STRATÉGIE DE PRODUCTION & PROTOCOLE D'AGENT (SANS MODIFICATION PRD SANS ACCORD)  

---

## 🧭 Table des Matières
1. [La Révolution Harmonist : Le Protocole Mécanique vs L'Invite Polie](#1-vision)
2. [L'Intégration dans ASCENT : L'Enforcement de Portes de Validation (Gates)](#2-integration)
3. [L'Architecture de Mémoire Persistante d'Étude (Session Handoff)](#3-memoire)
4. [Raccordement Technique à notre API Mastra (TypeScript) & Northflank (Postgres)](#4-raccordement)

---

## 1. La Révolution Harmonist : Le Protocole Mécanique vs L'Invite Polie {#1-vision}

### Le Problème de Sûreté Multi-Agents d'ASCENT
En intégrant **13 agents autonomes** dans la pipeline d'ASCENT (incluant le `VISUAL-CRITIC AGENT-12` et le `COGNITIVE-VALIDATOR AGENT-13`), nous sommes confrontés à un défi majeur : les modèles de langage (LLMs) ont une tendance naturelle à **sauter les consignes complexes de validation, à ignorer les alertes de dérives ou à bâcler les revues sémantiques** si elles sont simplement formulées sous forme d'invites textuelles polies (prompts).

### La Solution Harmonist (PyShine)
**Harmonist** est un framework open-source de niveau de production conçu par **GammaLab Technologies** (2026) sous Licence MIT. 

Sa philosophie de rupture est unique : **l'enforcement de protocoles est une porte mécanique, pas une requête polie dans un prompt.**

```
[Mastra Agent Workflow] ──► (Génère le cours / le graphe sémantique)
                                  │
                                  ▼
                     [Harmonist Hook-driven Gate] 
        (Intercepte la transaction et vérifie les signatures des évaluateurs)
                                  │
         ┌────────────────────────┴────────────────────────┐
         ▼ [Échec : Reviewers absents ou Score < 85]      ▼ [Succès]
   [Turn Rejected / Rollback]                      [Commit & Render dans l'UI]
```

#### Pourquoi Harmonist est un Game-Changer pour SCY Forge :
1. **Enforcement par Hooks (IDE & Backend levels)** : Chaque transaction de modification de base de données d'apprentissage (déblocage de nœud, modification de graphe sémantique) est interceptée par des crochets (hooks) logiciels. Si le `VISUAL-CRITIC (AGENT-12)` n'a pas signé et validé l'intégrité logique du graphe, la transaction est rejetée de manière mécanique, empêchant tout affichage d'hallucination à l'utilisateur.
2. **Mémoire Persistante par Session (Session-Handoff)** : Plus de perte de contexte. Harmonist structure la mémoire en 3 fichiers de schémas persistants liés par un identifiant de corrélation, permettant à l'apprenant de retrouver l'état exact de son cerveau sémantique à chaque réouverture de session.
3. **Index de Routage Dynamique (`agents/index.json`)** : Notre orchestrateur n'appelle pas les agents de manière hardcodée. Il interroge un registre d'agents s'appuyant sur un croisement de `tags`, de `catégories` et de `domaines` d'études, permettant d'ajouter ou de mettre à jour un agent de spécialité en production en 1 seconde sans toucher à la codebase.

---

## 2. L'Intégration dans ASCENT : L'Enforcement de Portes de Validation (Gates) {#2-integration)

Nous utilisons le concept de **Strict Reviewers** d'Harmonist pour s'assurer que notre cours et nos visuels respectent les normes d'SMI.

```yaml
# /harmonist/agents/review/visual-critic.md (Schema-v2)
---
name: visual-critic
description: Audite l'intégrité logique, sémantique et géométrique de chaque schéma ou graphe généré (COSMOS ou FlowSeek) avant affichage.
category: review
protocol: strict
readonly: true
is_background: true
model: inherit
tags: [ascent, visual, check, logic, review]
domains: [all]
---

Tu es l'agent de contrôle de sûreté visuelle et logique de SCY Forge. Tu agis comme une porte mécanique d'audit.

## RÈGLES DE CONFORMITÉ STRICTES :
1. Détection de cycle : Interdire toute relation circulaire de prérequis dans le DAG (A -> B -> A).
2. Vérification d'SMI : Rejeter le nœud si les types de relations d'arêtes ne sont pas validés ou traçables vers une source d'origine dans la base de données.
```

* **Le Geste Mécanique** : Si le code s'apprête à débloquer le nœud suivant, le hook de validation intercepté en Rust/Node.js appelle le `visual-critic` d'Harmonist. Si ce dernier retourne un score d'audit inférieur à 85/100, le changement de statut est **rejeté (Rollback)**.

---

## 3. L'Architecture de Mémoire Persistante d'Étude (Session Handoff) {#3-memoire}

Pour garantir la continuité de l'apprentissage (notamment pour l'agent `CHRONICLE` qui s'adapte aux imprévus de la vie), la mémoire utilisateur d'ASCENT est structurée selon le standard de persistance de session d'Harmonist :

| Fichier de Persistance | Rôle Cognitif pour SCY Forge |
|------------------------|------------------------------|
| `session-handoff.md`   | L'état actuel de la session d'étude : concepts étudiés, temps, fatigue détectée par le `FlowStateEstimator`. Lu à chaque ouverture de session par `CHRONICLE` pour un **Smart Resume** instantané. |
| `decisions.md`         | Journal des décisions d'apprentissage de l'utilisateur (ses choix de jalons, les branches logicielles sélectionnées). |
| `patterns.md`          | Journal d'acquisition cognitive : les concepts qui ont posé problème, les types de flashcards échouées, et les erreurs de l'ARENA. Permet à l'IA d'apprendre des faiblesses passées pour personnaliser la suite. |

* **Bénéfice** : Les données sont formatées sous forme de schémas Markdown (`SCHEMA.md` d'Harmonist) résistants aux injections et scannés de manière asynchrone contre les fuites de secrets.

---

## 4. Raccordement Technique à notre API Mastra (TypeScript) & Northflank (Postgres) {#4-raccordement}

Puisque nous utilisons le framework d'agents **Mastra** [1] hébergé sur Northflank et notre base de données **Northflank**, le raccordement d'Harmonist s'effectue sous la forme de **Mastra Step Hooks** :

```typescript
import { Step } from '@mastra/core';
import { runHarmonistGate } from './harmonist/enforcer';

export const validateVisualsStep = new Step({
  id: 'visual-validation-gate',
  execute: async ({ context }) => {
    // 1. Exécuter la porte d'enforcement d'audit mécanique d'Harmonist
    const auditResult = await runHarmonistGate({
      agent: 'visual-critic',
      data: context.generated_graph,
      schema: 'ascent-visual-v2'
    });
    
    // 2. Si l'audit échoue (score < 85), rejeter la transaction et enregistrer l'échec dans Northflank
    if (auditResult.score < 85) {
      await db.save_failed_audit(context.goal_id, auditResult);
      throw new Error(`[Harmonist Hook] Échec de la porte de validation sémantique visuelle. Score : ${auditResult.score}/100.`);
    }
    
    // 3. Si succès, enregistrer l'approbation de l'agent dans Northflank et autoriser la transaction
    await db.save_approved_audit(context.goal_id, auditResult);
    return { auditResult };
  }
});
```

En intégrant **Harmonist** en surcouche d'orchestration, vous dotez SCY Forge d'une **Sûreté Système Absolue**. L'IA d'apprentissage d'ASCENT et de validation d'SMI n'est plus guidée par des promesses de prompts, mais par un **cadre d'exécution déterministe et inviolable**, assurant un niveau de qualité et de confiance exceptionnel pour vos utilisateurs professionnels (B2B) et académiques.
