# SCYForge — Architecture

> Audience: agent de codage ou humain qualifie.  
> Objectif: comprendre les services, leurs dépendances et leur ordre d’implementation sans lire l’integralite du depot.

---

## 1. Principe fondateur

SCYForge est une plateforme d’apprentissage agentique mono-backend: le meme processus sert les agents Typescript, le moteur Rust, le frontend React et les services compagnons. Aucune limite de base n’est franchie: eventuel scale-out suppose d’abstraire d’abord les adapters.

Decoupage:
- couche calcul: Rust via des crates de services
- couche orchestration: Typescript via Mastra
- couche interface: React
- couche donnees: PostgreSQL + Zilliz + sidecars Docker
- couche communication: EventBus (zero appel direct inter-services)

---

## 2. Carte des modules executables

```
frontend_react/
   -> consomme backend_ts:
        /api/ascent/*
        /api/normal/*
        /api/b2b/*
        /api/auth/*
   -> consomme backend_rs:
        /health/*
        /api/cosmos/*
        /api/apex/*
        /api/brain/*

backend_ts/
   -> orchestrateurs ASCENT / Normal Mode / B2B
   -> appelle backend_rs:
        /ingestion/*
        /neuron-chains/*
        /apex/fsrs/*
        /cosmos/*
        /brain/*
        /reader/*
        /imprint/*
        -> toujours par API; jamais de dependance code->code

backend_rs/
   -> sert d’API et fournit les services transverses
   -> publie des events dans EventBus
   -> consomme:
        PostgreSQL / Zilliz / SearxNG / Perplexica / Nango / LLMs
```

---

## 3. EventBus: regle d’or

Service 1: l’EventBus (`scy-eventbus`) etablit le contrat inter-services.
Regles:
- zero appel direct entre services transverses
- consommation par IDs de topics ou filtres
- edition garantie au moins une fois
- DLQ pour les events en echec

---

## 4. Services traverses et consommateurs

Service 1: NEURON-CHAINS
- responsabilite: generer docs, cartes et exercices
- consomme: INGESTION CORES, PostgreSQL, Zilliz, LLMs
- est appele par: ASCENT, Normal Mode, B2B, BRAIN, Reader Suite, ARENA

Service 2: APEX / FSRS
- responsabilite: retention et cartes
- consomme: PostgreSQL, LLMs
- est appele par: ASCENT, Normal Mode, COSMOS, IMPRINT

Service 3: COSMOS
- responsabilite: graphe de connaissance et visualisations
- consomme: PostgreSQL, Zilliz, scy-cosmos-kg
- est appele par: ASCENT, APEX, BRAIN, Reader Suite, Normal Mode, DAG Display

Service 4: BRAIN
- responsabilite: assistant conversationnel et retrieval
- consomme: PostgreSQL, Zilliz, SearxNG, Perplexica
- est appele par: ASCENT, APEX, CHRONICLE, Reader Suite, ARENA

Service 5: INGESTION CORES
- responsabilite: ingestion multi-format
- consomme: PostgreSQL, sidecars Docker, LLMs
- est appele par: ASCENT, Normal Mode, B2B, NEURON-CHAINS, COSMOS, BRAIN

Service 6: Reader Suite
- responsabilite: lecture enrichie multi-format
- consomme: PostgreSQL, Brain, NEURON-CHAINS
- est appele par: COSMOS, APEX, BRAIN, citations deep link

Service 7: IMPRINT
- responsabilite: distillation cognitive courte
- consomme: NEURON-CHAINS, APEX, PostgreSQL
- est appele par: ASCENT, APEX, Reader Suite

Service 8: EventBus
- responsabilite: communication asynchrone
- consomme: tous les services emetteurs
- est appele par: tous les services consommateurs

---

## 5. Ordre d’implementation bottom-up

Phase 0:
1. EventBus
2. PostgreSQL et Zilliz
3. Ingestion Cores

Phase 1:
4. NEURON-CHAINS
5. APEX / FSRS
6. COSMOS

Phase 2:
7. BRAIN
8. Reader Suite
9. IMPRINT

Phase 3:
10. ASCENT Pipeline
11. Normal Mode
12. B2B Console

Phase 4:
13. CHRONICLE
14. ARENA

Regle:
- un module ne doit pas dependre d’un module posterieur dans cette liste

---

## 6. Contraintes de couplage

Interdit:
- appel direct entre deux services traverses
- import code a code d’un service dans un autre
- lecture/ecriture partagee d’une table proprietaire sans API ou EventBus

Obligatoire:
- communication par API ou par EventBus
- validation d’entree a chaque frontiere
- journalisation des appels entre services

---

## 7. Boundaries d’implementation

Backend Rust:
- les services traverses sont des crates dans backend_rs/crates
- les consommateurs sont dans backend_rs/src/ascent, backend_rs/src/normal_mode, backend_rs/src/b2b
- jamais de logique metier dans backend_rs/src/infra

Backend Typescript:
- les orchestrateurs sont dans backend_ts/src/ascent, backend_ts/src/normal_mode, backend_ts/src/b2b
- les schemas sont dans backend_ts/src/ascent/schemas
- les prompts sont dans backend_ts/src/ascent/prompts

Frontend React:
- les features sont dans frontend_react/src/<feature>
- les stores sont dans frontend_react/src/stores
- les engines couteux sont lazy-loaded dans frontend_react/src/cosmos/engines
