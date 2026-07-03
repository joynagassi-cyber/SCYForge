<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Harmonist gates GARDÉES. Trust gates intégrité.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# Module 9 : Double-Portail de Sûreté & Harmonist Protocol — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : S09_HARMONIST_VALIDATION_GATES  
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
* **Description Fonctionnelle** : Enforcement mécanique de validation de transactions logiques d'agents.
* **Stack Technique Officielle** : Mastra TS, Zod Validation, Harmonist hooks (TypeScript)
* **Patterns d'Ingénierie à Respecter** : Factual Gate (DELTA), Cognitive & Visual Gate (Zod auto-retries)

---

# 🛡️ MODULE 9 : Harmonist Validation Gates — Spécifications de Codage

## 1. Description du Module
Harmonist intercepte les transactions de base de données d'apprentissage. Si le schéma de graphe (COSMOS) échoue à la validation d'intégrité Zod par `AGENT-12` (Visual-Critic), la transaction est rejetée et un auto-retry immédiat s'active.


---

## 🛑 DIRECTIVES STRICTES CONTRE L'HALLUCINATION (AI DE CODELING)
Pour garantir la réussite absolue du codage de ce module par nos agents de développement :
1. **Ne jamais inventer d'APIs tierces** : Utilise scrupuleusement les bibliothèques et connecteurs listés dans la stack.
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Northflank.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.
