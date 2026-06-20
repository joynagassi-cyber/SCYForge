# Module 5 : APEX — Active Practice & Expertise System — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : S05_APEX_RETENTION_SYSTEM  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

---

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : Le moteur de révision espacée et de calcul d'index d'expertise.
* **Stack Technique Officielle** : Rust (APEX-FSRS Crate), TypeScript (FSRS.js fallback), Northflank PostgreSQL
* **Patterns d'Ingénierie à Respecter** : Algorithme FSRS 5.0, STUDENT AI Teach-Back Engine, SMI Calculator

---

# 🃏 MODULE 5 : APEX — Active Practice & Expertise System — Spécifications de Codage

## 1. Description du Module
APEX gère l'entraînement actif. Il calcule le calendrier des cartes mémoires à réviser via FSRS 5.0, calcule le score SMI à 5 dimensions et fait passer l'examen oral **STUDENT AI**.

## 2. Le Moteur de Calcul d'SMI (Rust)
```rust
// backend_rust/src/neurochain/apex/smi_calculator.rs
pub struct SmiProfile {
    pub retention: f32, // APEX cards stability
    pub precision: f32, // Quiz score
    pub speed: f32,     // Duration score
    pub depth: f32,     // Bloom level achieved
    pub application: f32, // ARENA performance
}

impl SmiProfile {
    pub fn calculate_smi(&self) -> f32 {
        // Moyenne harmonique pondérée
        5.0 / ( (1.0/self.retention) + (1.0/self.precision) + (1.0/self.speed) + (1.0/self.depth) + (1.0/self.application) )
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


## Spécifications de Sûreté Cognitive APEX & STUDENT-AI (v3.5)

### A. Diagnostic de Pannes Sémantiques vs Logiques (Teach-Back)
Si un étudiant obtient un score d'explication orale ou écrite inférieur à 40% lors de sa session Teach-Back face à l'élève virtuel **STUDENT-AI** :
1. L'agent analyse sémantiquement la transcription de la session.
2. Il diagnostique la nature de la faille :
   - *Faille Sémantique* : Vocabulaire, définitions ou terminologies mal assimilées.
   - *Faille Logique* : Liens de cause à effet ou raisonnements brisés (graphe relationnel invalide).
3. Il transmet ce diagnostic précis de panne à la Neuro-Chain Rust pour **générer une fiche d'analogie ciblée de type B06 (Analogy)** pour aider l'élève.

### B. Barrière de Stabilité FSRS avant ARENA
L'accès aux simulations complexes de l'**ARENA** (`AGENT-11` gérant les niveaux de Bloom Analyse/Création) est **strictement verrouillé** tant que la stabilité cognitive FSRS (`Stability`) calculée pour chaque concept prérequis du nœud n'est pas **supérieure ou égale à 3.0 jours**. Cela garantit une base mémorielle saine et consolidée avant de soumettre le cerveau à la charge de travail d'un cas de crise.

