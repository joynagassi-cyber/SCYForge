# project_context_short.md — SCY Forge en 2 min

> *Condensé de `minddoc/PROJECT_CONTEXT.md` V1.0 — 2026-07-02*

**Quoi** : Plateforme d'apprentissage agentique. L'utilisateur déclare un objectif → 18 agents IA orchestrent ingestion, génération, rétention, certification. **Zéro friction. Règle des 2 clics.**

**3 Piliers** :
1. Semantic Tree + DCID — Structure unique du savoir (cerveau apprenant + savoir entreprise + architecture produit)
2. ASCENT Pipeline — 18 agents (13 IN_MVP + 5 POST_MVP) transmettent objectif → autonomie prouvée
3. Generative Forest Engine — Création de savoir nouveau (Pollination → Seed → Germination, mode observatoire MVP)

**Beachhead MVP (Jours 1-28)** : Cyber SOC/Blue-Team
- Source contenu : MITRE ATT&CK pré-ingéré ($0 LLM)
- Features IN_MVP : Semantic Tree, ASCENT 13 agents, COSMOS V5 (4 modes), Tactical AI (DeepSeek V4 Free), Dashboard SOC Manager, Onboarding < 5min, Proof of Skill, GFE observatoire
- Features différées Post-MVP : NEURON-CHAINS, ARENA (6 domaines), CHRONICLE, 11 Ingestion Cores, Reader Suite, B2B Creator Console, Finance Suite

**Stack** : Rust + Axum (calcul) | TypeScript + Mastra (orchestration) | React 18 + Vite + Tailwind (frontend) | PostgreSQL 15+ + pgvector + Zilliz (DB + vector) | SearxNG sidecar (recherche)

**Règles d'or** :
- Zéro terme métier cyber dans le core → tout vit dans `packs/cyber/`
- Tout seuil/poids est pack-défini
- Extensibilité par conception (nouveau domaine = nouveau pack)
- EventBus obligatoire (zéro appel direct inter-services)
- 9 Providers DCID + 5 opérations canoniques par Domain Pack
- Typestate Pattern + 3 instances Semantic Tree (DomainPack, Organization, Learner)

**Ordre d'implémentation** (bottom-up) :
EventBus → scy-shared → PostgreSQL/Zilliz → SemanticTree/DCID → Pack Loader → APEX/FSRS → COSMOS → Tactical AI → ARENA-lite → Onboarding → Tests → Deploy

**Documentation** : `minddoc/` contient toutes les specs et l'architecture. `docs/` contient les fichiers opérationnels (roadmap, build, style, structure). Code dans `backend_rs/`, `backend_ts/`, `frontend_react/`.

**Référence** : `MASTER_AGENT_PROMPT_V2.md` pour la méthodologie 10 phases.
