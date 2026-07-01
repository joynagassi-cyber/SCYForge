# MindDoc — Index

## Produit et exigences

### s00_prd/
- **[index.md](./s00_prd/index.md)** - Index du PRD consolidé et exigences maîtres
- **[scy_prd_part_1_strategy.md](./s00_prd/scy_prd_part_1_strategy.md)** - Vision produit, personas et stratégie B2B
- **[scy_prd_part_2_ascent_pipeline.md](./s00_prd/scy_prd_part_2_ascent_pipeline.md)** - Pipeline ASCENT et 13 agents autonomes
- **[scy_prd_part_3_neuron_chains.md](./s00_prd/scy_prd_part_3_neuron_chains.md)** - NEURON-CHAINS v2 et méta-orchestrateur APEX
- **[scy_prd_part_4_apex_retention.md](./s00_prd/scy_prd_part_4_apex_retention.md)** - APEX/FSRS 5.0 et STUDENT AI Teach-Back
- **[scy_prd_part_5_cosmos_modes.md](./s00_prd/scy_prd_part_5_cosmos_modes.md)** - 26 modes COSMOS et suite sémantique
- **[scy_prd_part_6_architecture_db.md](./s00_prd/scy_prd_part_6_architecture_db.md)** - Conventions BDD et configuration infrastructure
- **[scy_epics_and_stories.md](./s00_prd/scy_epics_and_stories.md)** - Epics et user stories avec critères Given/When/Then

## Design et expérience

### s00_design/
- **[scy_design_system.md](./s00_design/scy_design_system.md)** - Tokens de design (couleurs, typographie, espacement)
- **[scy_experience_design.md](./s00_design/scy_experience_design.md)** - Principes d'expérience utilisateur
- **[scy_apex_revision_simulator.html](./s00_design/scy_apex_revision_simulator.html)** - Simulateur de révision APEX
- **[scy_arena_vocal_simulator.html](./s00_design/scy_arena_vocal_simulator.html)** - Simulateur vocal Arena
- **[scy_brain_panel_simulator.html](./s00_design/scy_brain_panel_simulator.html)** - Simulateur panel BRAIN

## Architecture et standards

### s00_architecture_standards/
- **[index.md](./s00_architecture_standards/index.md)** - Index des standards d'architecture
- **[scy_service_architecture_map.md](./s00_architecture_standards/scy_service_architecture_map.md)** - Cartographie des 8 services transverses
- **[scy_agentic_vision_complete.md](./s00_architecture_standards/scy_agentic_vision_complete.md)** - Vision agentique complète
- **[scy_agentic_sdlc_standards.md](./s00_architecture_standards/scy_agentic_sdlc_standards.md)** - Standards SDLC agentique
- **[scy_progressive_automation_spec.md](./s00_architecture_standards/scy_progressive_automation_spec.md)** - Spécification automation progressive
- **[scy_integration_hub_architecture.md](./s00_architecture_standards/scy_integration_hub_architecture.md)** - Architecture Integration Hub
- **[scy_multi_agent_pipeline_patterns.md](./s00_architecture_standards/scy_multi_agent_pipeline_patterns.md)** - Patterns pipelines multi-agents
- **[scy_livekit_voice_spec.md](./s00_architecture_standards/scy_livekit_voice_spec.md)** - Spécification voix LiveKit
- **[scy_wasm_edge_spec.md](./s00_architecture_standards/scy_wasm_edge_spec.md)** - Spécification WASM edge computing
- **[scy_pricing_tiers_spec.md](./s00_architecture_standards/pricing_tiers/scy_pricing_tiers_spec.md)** - Grille tarification
- **[scy_ux_ui_spec.md](./s00_architecture_standards/ux_ui_features/scy_ux_ui_spec.md)** - Spec UX/UI features
- **[scy_crates_standards_spec.md](./s00_architecture_standards/crates_standards/scy_crates_standards_spec.md)** - Standards crates Rust
- **[scy_engineering_safeguards_spec.md](./s00_architecture_standards/engineering_safeguards/scy_engineering_safeguards_spec.md)** - Gardes fous ingénierie
- **[scy_infra_sec_spec.md](./s00_architecture_standards/infrastructure_securite/scy_infra_sec_spec.md)** - Spécification infrastructure et sécurité

## Modules métier

### s01 à s12 — Modules core
- **[s01_ingestion_cores/](./s01_ingestion_cores/)** - Specs 13 cores d'ingestion
- **[s02_neuron_chains_apex_agent/](./s02_neuron_chains_apex_agent/)** - Specs NEURON-CHAINS et APEX
- **[s03_ascent_pipeline_agents/](./s03_ascent_pipeline_agents/)** - Specs ASCENT (18 agents + QA)
- **[s04_scy_cosmos_visualization_engine/](./s04_scy_cosmos_visualization_engine/)** - Specs COSMOS (26 modes)
- **[s05_apex_retention_system/](./s05_apex_retention_system/)** - Specs APEX/FSRS
- **[s06_scy_brain_rag_assistant/](./s06_scy_brain_rag_assistant/)** - Specs BRAIN RAG
- **[s07_scy_imprint_cognitive/](./s07_scy_imprint_cognitive/)** - Specs IMPRINT cognitif
- **[s08_scy_reader_suite/](./s08_scy_reader_suite/)** - Specs Reader Suite
- **[s09_harmonist_validation_gates/](./s09_harmonist_validation_gates/)** - Specs Harmonist
- **[s10_normal_mode_ingestion/](./s10_normal_mode_ingestion/)** - Specs Normal Mode
- **[s11_neuroscientific_engine/](./s11_neuroscientific_engine/)** - Specs Neuroscience Engine
- **[s12_b2b_creator_console/](./s12_b2b_creator_console/)** - Specs B2B Creator Console

### s13 — Cyber operational
- **[s13_pivotiq_reconciliation/](./s13_pivotiq_reconciliation/)** - Specs PIVOTIQ — réconciliation multi-sources SOC

### s14 — Finance & analytics
- **[s14_finance_suite/](./s14_finance_suite/)** - Specs FINANCE SUITE — Pipeline Data Analyst Financier

## Domain Packs

### packs/
- **[packs/cyber/](./packs/cyber/)** - Cyber Pack v0.2.0 — Domain Pack cybersecurity (ONTOLOGY + ROLES + SCENARIOS + CORPUS)
  - `pack.manifest.json` — manifest du pack (version, providers, artifacts, sources)
  - `ontology/` — ATT&CK hierarchy, density, semantic tree, ontologie complète
  - `roles/` — taxonomy des rôles SOC / blue-team
  - `scenarios/` — chaîne APT29 complète + scénarios ARENA + barème proof-of-skill
  - `corpus/` — corpus fondateur SCYForge
  - `scripts/` — génération du semantic tree cyber
