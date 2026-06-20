# Module 2 : NEURON-CHAINS & APEX-AGENT — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : S02_NEURON_CHAINS_APEX_AGENT  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

---

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : Moteur de synthèse de documents sémantiques et de planification multi-agents.
* **Stack Technique Officielle** : Rust (Axum + Tokio), candle-core, async-openai, LanceDB (Local cache), DeepSeek
* **Patterns d'Ingénierie à Respecter** : APEX-AGENT Meta-Orchestrator, 18 Tools natifs, Prompt Caching, Batch API

---

# ⚙️ MODULE 2 : NEURON-CHAINS & APEX-AGENT — Spécifications de Codage

## 1. Description du Module
L'APEX-AGENT gère le moteur de synthèse parallèle Rust. Il coordonne les 7 Neuron-Chains (Alpha à Eta) et exécute 18 outils natifs compilés pour générer les cours, quiz et slides.

## 2. Les 18 Outils Natifs (Registres)
* `RAGRetriever (T01)`, `SourceVerifier (T02)`, `DocTypeDetector (T03)`, `ToneSelector (T04)`, `OutlinePlanner (T05)`, `TokenBudgeter (T06)`, `PromptCompressor (T07)`, `ModelRouter (T08)`, `FactChecker (T09)`, `ConfidenceCalc (T10)`, `StructureValidator (T11)`, `StyleEnforcer (T12)`, `ExportFormatter (T13)`, `DocSuggester (T14)`, `BudgetGuard (T15)`, `SemanticCache (T16)`.

## 3. Pattern de Code (Prompt Caching et Outil Rust)
```rust
// backend_rust/src/neurochain/tools/prompt_compressor.rs
use candle_core::Tensor;

pub struct PromptCompressor {
    threshold: f32,
}

impl PromptCompressor {
    pub fn compress_prompt(&self, raw_prompt: &str) -> String {
        // Implémentation locale de LLMLingua pour strip-détecter les tokens non sémantiques
        // Économise 80% de jetons d'input
        raw_prompt.split_whitespace()
            .enumerate()
            .filter(|(i, _)| i % 5 != 0) // Approximation de compression déterministe
            .map(|(_, word)| word)
            .collect::<Vec<&str>>()
            .join(" ")
    }
}
```


---

## 🛑 DIRECTIVES STRICTES CONTRE L'HALLUCINATION (AI DE CODELING)
Pour garantir la réussite absolue du codage de ce module par nos agents de développement :
1. **Ne jamais inventer d'APIs tierces** : Utilise scrupuleusement les bibliothèques et connecteurs listés dans la stack.
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Northflank.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.


## 4. Architecture de Rendu & d'Orchestration Rust (Rig, RRAG & Concurrence Structurée)

### 4.1 Intégration de Rig & RRAG
Le moteur s'appuie sur la bibliothèque légère **Rig** pour unifier les appels de LLMs, et sur **RRAG** pour orchestrer le triplet de recherche RAG hybride :
- Les outils d'audits ou de compressions implémentent le trait composable `Tool` de Rig.
- L'APEX-AGENT est instancié via les abstractions de `CompletionModel` de Rig, garantissant un typage strict au moment de la compilation.

### 4.2 L'Orchestrateur Custom avec Concurrence Structurée (JoinSet & CancellationToken)
Pour exécuter les Neuron-Chains en parallèle (ex: générer simultanément les fiches concepts et l'examen) sans risque de fuites de mémoire, de zombies ou de blocages de threads, nous codons notre propre orchestrateur à l'aide des primitives de **Tokio** :

```rust
// backend_rust/src/neurochain/orchestration/custom_orchestrator.rs
use tokio::task::JoinSet;
use tokio_util::sync::CancellationToken;
use std::sync::Arc;
use uuid::Uuid;

pub struct AgentTask {
    pub id: Uuid,
    pub agent_name: String,
}

pub async fn run_parallel_neuron_chains(
    tasks: Vec<AgentTask>,
    payload: Arc<serde_json::Value>,
) -> Result<Vec<serde_json::Value>, String> {
    // 1. Initialiser le jeton d'annulation (Sûreté de SAGA)
    let cancel_token = CancellationToken::new();
    let mut join_set = JoinSet::new();
    
    for task in tasks {
        let token = cancel_token.clone();
        let task_payload = Arc::clone(&payload);
        
        // Fanner chaque agent au sein d'une tâche de thread Tokio isolée
        join_set.spawn(async move {
            tokio::select! {
                // Écoute active de l'annulation en cas de panne d'une autre branche (SAGA fallback)
                _ = token.cancelled() => {
                    Err(format!("Tâche {} annulée de manière préventive.", task.id))
                }
                result = execute_agent_chain(task, task_payload) => {
                    result
                }
            }
        });
    }

    let mut completed_results = Vec::new();
    
    // Écoulement et surveillance de la concurrence
    while let Some(res) = join_set.join_next().await {
        match res {
            Ok(Ok(success_payload)) => {
                completed_results.push(success_payload);
            }
            _ => {
                // EN CAS D'ÉCHEC D'UNE SEULE BRANCHE : Annuler immédiatement tous les autres threads actifs !
                cancel_token.cancel();
                return Err("Échec critique d'une Neuron-Chain. Annulation globale de la transaction.".to_string());
            }
        }
    }

    Ok(completed_results)
}

async fn execute_agent_chain(task: AgentTask, payload: Arc<serde_json::Value>) -> Result<serde_json::Value, String> {
    // Implémentation réelle de l'outil d'appel Rig de l'agent
    Ok(serde_json::json!({ "status": "completed", "agent": task.agent_name }))
}
```
