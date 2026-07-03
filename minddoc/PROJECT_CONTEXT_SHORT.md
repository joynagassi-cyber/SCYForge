# PROJECT_CONTEXT_SHORT.md — SCY Forge (2 min)

**Quoi** : Plateforme d'apprentissage agentique. L'utilisateur déclare un objectif → agents IA orchestrent ingestion, génération, rétention, certification.
**Promesse** : "Zéro friction. Règle des 2 clics."

**3 Piliers** :
1. Semantic Tree + DCID — Structure du savoir
2. ASCENT Pipeline — 13 agents transmettent le savoir
3. Generative Forest Engine — Création de savoir nouveau (Seeds)

**Beachhead MVP** : Cyber SOC/Blue-Team (MITRE ATT&CK pré-ingéré, $0 LLM)
**Stack** : Rust + Axum (backend calcul) | TypeScript + Mastra (orchestration) | React 18 + Vite + Tailwind (frontend) | PostgreSQL + Zilliz (DB + vector)

**Règles d'or** :
- Zéro terme métier cyber dans le core
- Tout seuil est pack-défini
- Extensibilité par conception (nouveau domaine = nouveau pack)
- EventBus obligatoire (zéro appel direct inter-services)
- 9 Providers DCID par Domain Pack

**Ordre d'implémentation** :
EventBus → PostgreSQL/Zilliz → SemanticTree/DCID → Pack Ingestion → APEX/FSRS → COSMOS → Tactical AI → BudgetGuard → GFE → ASCENT (consumers)

**Documentation** : `minddoc/` contient toutes les specs et l'architecture. `docs/` contient les fichiers opérationnels (roadmap, build, style). Le code est dans `backend_rs/`, `backend_ts/`, `frontend_react/`.

**Référence** : `MASTER_AGENT_PROMPT_V2.md` pour les 10 phases documentaires.
