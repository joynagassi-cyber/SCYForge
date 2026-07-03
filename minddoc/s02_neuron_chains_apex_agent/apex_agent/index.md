# 🗺️ index LOCAL : APEX_AGENT

Ce sous-répertoire gère l'implémentation du **APEX-AGENT** — le méta-orchestrateur interne des NEURON-CHAINS (distinct de l'ASCENT-ORCHESTRATOR). Il pilote la génération documentaire via une boucle ReAct (Reason → Act → Observe) et coordonne les 7 chaînes + 18 tools.

## 📁 Gabarits de Sûreté d'Écriture (MANDATORY READ)
- `scy_apex_agent_spec.md` / `scy_apex_agent_plan.md` / `scy_apex_agent_tasks.md` / `scy_apex_agent_tests.md`

## 🔗 Décisions d'architecture
D-OPT-057 (Rig), D-OPT-058 (RRAG), D-OPT-059 (custom orchestrator JoinSet/CancellationToken), NC-001 à NC-006.

Référez-vous à **`s00_architecture_standards/`** et au PRD §5.2.
