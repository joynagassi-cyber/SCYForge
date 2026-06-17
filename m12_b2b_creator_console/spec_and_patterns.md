# Module 12 : B2B Cohort & Creator Console — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : M12_B2B_CREATOR_CONSOLE  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

---

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : Tableau de bord pour formateurs et créateurs de contenu.
* **Stack Technique Officielle** : React 18, Insforge PostgreSQL, Zilliz Serverless
* **Patterns d'Ingénierie à Respecter** : k-anonymity (k >= 10), Global Heat Map, mfg_sync_queue WAL

---

# 📊 MODULE 12 : B2B Cohort & Creator Console — Spécifications de Codage

## 1. Description du Module
Permet aux créateurs de contenu de suivre l'SMI de leur cohorte, d'identifier les goulots cognitifs, d'injecter des clarifications en un clic (RAG) et d'utiliser une file IndexedDB WAL résiliente aux pannes.


---

## 🛑 DIRECTIVES STRICTES CONTRE L'HALLUCINATION (AI DE CODELING)
Pour garantir la réussite absolue du codage de ce module par nos agents de développement :
1. **Ne jamais inventer d'APIs tierces** : Utilise scrupuleusement les bibliothèques et connecteurs listés dans la stack.
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Insforge.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.
