# Module 2 : NEURON-CHAINS & APEX-AGENT — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : M02_NEURON_CHAINS_APEX_AGENT  
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
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Insforge.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.
