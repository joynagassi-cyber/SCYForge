# SCYForge — Agent Guide

> Audience: agent de codage ou humain qualifie.  
> Objectif: coder dans SCYForge sans contourner l’architecture, les conventions ou les regles de qualite.

Ce document est prescriptif.  
Si un point est en contradiction avec un autre document, la regle la plus specifique ou la plus recente fait autorite.

---

## 1. Sequence de lecture avant toute modification

1. `AGENTS.md` — instructions permanentes
2. `docs/PROJECT_STRUCTURE.md` — structure du code autorisee
3. `docs/ARCHITECTURE.md` — services et dependances
4. `docs/ROUTES.md` — contrats HTTP et MCP
5. `docs/WORKFLOWS.md` — roles et modes operationnels
6. `docs/DATA_MODEL.md` — schema de donnees et contraintes
7. `docs/AGENT_GUIDE.md` — ce document
8. specs du sujet:
   - `minddoc/s0X_module/sous_feature/scy_*_spec.md`
   - `minddoc/s0X_module/sous_feature/scy_*_plan.md`
   - `minddoc/s0X_module/sous_feature/scy_*_tasks.md`
   - `minddoc/s0X_module/sous_feature/scy_*_tests.md`

Regle:
- ne pas coder avant la lecture complete du bloc spec + plan + tasks + tests du sujet

---

## 2. Limites systeme a respecter

Interdiction absolue:
- toute modification dans `minddoc/s00_prd/`
- toute introduction de crate ou package sans validation explicite
- toute appel LLM payant pour une operation marquee `$0`
- toute creation d’un sidecar Docker non documente
- toute dependance non autorisee ou non listee dans une spec validee
- toute fuite de secret dans les logs ou les fichiers

---

## 3. Principes a appliquer systematiquement

- architecture hexagonale: Domain sans dependance infra
- decouplage par EventBus, jamais d’appel direct entre services
- validation d’entree: Zod en TS, serde derive en Rust
- tests: coverage cible >= 80%; property-based tests pour les invariants mathematiques
- erreurs structurees: `{data, error}` ou equivalent
- isolement par utilisateur: RLS PostgreSQL et checks explicites

---

## 4. Cycles et ports autorises par cote

Backend Rust:
- caller exclusivement les ports exposes par API interne ou EventBus
- ne pas importer directement un consumer comme ASCENT dans un crate de service
- utiliser les traits Repository pour tout acces donnees

Backend TypeScript:
- consommer les routes backend_rs uniquement
- utiliser Zod pour toutes les entrees
- pas de logique metier dans le routing; Router -> Service -> Adapter

Frontend React:
- consommer uniquement les routes backend_ts ou backend_rs documentees dans `docs/ROUTES.md`
- utiliser les tokens design existants
- lazy loader obligatoire pour les engines COSMOS couteux

---

## 5. Verification avant commit

Checklist:
- [ ] lus la spec, le plan, les tasks et les tests du sujet?
- [ ] le code est dans l’arborescence autorisee par `docs/PROJECT_STRUCTURE.md`?
- [ ] pas d’appel direct inter-services en dehors de `docs/ROUTES.md`?
- [ ] validation d’entree presente et typage fort?
- [ ] tests executes et passes localement?
- [ ] lint et format respectes?
- [ ] pas de secret, pas de log sensible, pas de print debug en production?

---

## 6. Anti-patterns a eviter

- code metier dans l’infra
- duplication de logique entre deux services
- return `any` en TS ou return generique non typed en Rust
- absence de timeout sur les appels externes
- absence de test pour un nouveau comportement
- commit multiple sans message clair et sans lien avec une task validee

---

## 7. Quand demander une validation humaine

Demander avant de:
- modifier le schema de donnees
- ajouter une nouvelle dependance
- changer un contrat d’API utilise par un autre service
- activer un LLM payant pour un flux initialement marque `$0`
- introduire un nouveau sidecar Docker
- changer une limite de securite ou de budget

---

## 8. Ordre d’implementation a respecter

1. EventBus
2. PostgreSQL, Zilliz, sidecars de base
3. Ingestion Cores
4. NEURON-CHAINS
5. APEX / FSRS
6. COSMOS
7. BRAIN
8. Reader Suite
9. IMPRINT
10. ASCENT Pipeline
11. Normal Mode
12. B2B
13. CHRONICLE
14. ARENA

Un module ne doit pas dependre d’un module posterieur dans cette liste.

---

## 9. Format de travail attendu

- franais dans les specs et commentaires
- anglais autorise pour le code et les noms techniques
- messages de commit au format Conventional Commits
- toute nouvelle feature documentee dans la doc technique correspondante
- toute regression corrigee referencee par son id de bug ou de task

---

## 10. Reseau d’information utile

- `docs/ARCHITECTURE.md` pour les services
- `docs/ROUTES.md` pour les contrats
- `docs/WORKFLOWS.md` pour les roles et les modes
- `docs/DATA_MODEL.md` pour les tables
- `docs/AGENT_GUIDE.md` pour les regles
- `minddoc/s00_architecture_standards/scy_service_architecture_map.md` pour la matrice de consommation
- `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` pour les invariants techniques
- `minddoc/s0X_*/` pour les specs detaillees de chaque module
