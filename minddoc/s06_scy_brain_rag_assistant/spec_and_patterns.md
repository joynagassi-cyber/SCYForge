<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
BRAIN en MVP simplifié (BM25 FTS uniquement). Triple retrieval + live web différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# Module 6 : SCY-BRAIN — RAG & Conversational Assistant — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : S06_SCY_BRAIN_RAG_ASSISTANT  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

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

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : L'assistant conversationnel central (Professor AI) s'appuyant sur un RAG hybride.
* **Stack Technique Officielle** : Zilliz Cloud Serverless / Milvus Lite, Graphiti (Zep), LiteLLM, Vercel AI SDK
* **Patterns d'Ingénierie à Respecter** : Socratic Progressive Prompting, Thread-of-Thought Scaffolding, RRF Fusion

---

# 🧠 MODULE 6 : SCY-BRAIN — RAG & Assistant — Spécifications de Codage

## 1. Description du Module
SCY-BRAIN fournit des explications socratiques personnalisées grâce à un double RAG (fichiers privés et web) consolidé chronologiquement par Graphiti.

## 2. Socratic progressive prompting & Thread-of-Thought
- Limitation stricte de la génération du Professor AI à un maximum de **2 paragraphes socratiques** par interaction.
- Insertion obligatoire d'une question ciblée de rappel actif à la fin de la réponse.
- Utilisation de **Thread-of-Thought Scaffolding** pour relier l'explication aux concepts parents maîtrisés par l'étudiant.


---

## 🛑 DIRECTIVES STRICTES CONTRE L'HALLUCINATION (AI DE CODELING)
Pour garantir la réussite absolue du codage de ce module par nos agents de développement :
1. **Ne jamais inventer d'APIs tierces** : Utilise scrupuleusement les bibliothèques et connecteurs listés dans la stack.
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Northflank.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.
