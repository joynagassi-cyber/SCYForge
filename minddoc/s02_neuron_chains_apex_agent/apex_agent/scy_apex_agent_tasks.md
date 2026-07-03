<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
NEURON-CHAINS DIFFÉRÉ. Contenu pré-construit dans pack cyber. Revenir post-MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-APEX-AGENT — TÂCHES (TASKS)
**ID** : S02_NEURON_APEX_AGENT_TASKS

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | DEFERRED |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• **Ce module n'est PAS dans le beachhead MVP**
• La spec est conservée pour référence Phase 2+
• Voir PIVOT_ARCHITECTURE §3

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

### Tâche AX.1 : Coder la boucle ReAct (Reason→Act→Observe) (30 min)
* **Fichier** : `backend_rs/src/neurochain/apex_agent/react_loop.rs`
* **Description** : Boucle ReAct appelant T01-T06 (reason), génération+T10+T11 (act), T12 (observe/décision).
* **Critère** : Demande → raisonnement → génération → scoring → décision export/réécriture/alerte.

### Tâche AX.2 : Coder l'orchestrateur parallèle JoinSet + CancellationToken (25 min)
* **Fichier** : `backend_rs/src/neurochain/orchestration/custom_orchestrator.rs`
* **Description** : Fan-out des chaînes via JoinSet, CancellationToken, SAGA fallback (échec → annulation globale, D-OPT-059).
* **Critère** : Chaînes parallèles ; échec d'une branche → annulation immédiate des autres.

### Tâche AX.3 : Intégrer Rig + RRAG (20 min)
* **Fichier** : `backend_rs/src/neurochain/apex_agent/react_loop.rs`
* **Description** : Instanciation APEX-AGENT via Rig CompletionModel + Tool composables + RRAG récupération hybride (D-OPT-057/058).
* **Critère** : Typage strict compilation ; RAG hybride opérationnel.

### Tâche AX.4 : Coder les seuils de décision + traçabilité (20 min)
* **Fichier** : `backend_rs/src/neurochain/apex_agent/react_loop.rs`
* **Description** : Seuils (≥85 export / 70-84 ciblé / 45-69 complet / <45 alerte) + journalisation `scy_agent_decisions`.
* **Critère** : Décisions correctes ; traçabilité complète.
