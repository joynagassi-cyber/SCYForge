# Module 10 : Ingestion Mode Normal (On-Demand) — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : M10_NORMAL_MODE_INGESTION  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

---

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : Ingestion et synthèse de documents à la demande sans cursus structuré.
* **Stack Technique Officielle** : Mastra TS, Rust Axum API, Insforge PostgreSQL
* **Patterns d'Ingénierie à Respecter** : On-demand ingestion, Custom Prompting, StyleEnforcer

---

# 📥 MODULE 10 : Ingestion Mode Normal (On-Demand) — Spécifications de Codage

## 1. Description du Module
Permet à l'utilisateur de glisser un fichier en Mode Normal et d'obtenir instantanément le **Pack Neural par Défaut** rédigé selon ses propres consignes textuelles courtes.


---

## 🛑 DIRECTIVES STRICTES CONTRE L'HALLUCINATION (AI DE CODELING)
Pour garantir la réussite absolue du codage de ce module par nos agents de développement :
1. **Ne jamais inventer d'APIs tierces** : Utilise scrupuleusement les bibliothèques et connecteurs listés dans la stack.
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Insforge.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.
