# Module 5 : APEX — Active Practice & Expertise System — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : M05_APEX_RETENTION_SYSTEM  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

---

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : Le moteur de révision espacée et de calcul d'index d'expertise.
* **Stack Technique Officielle** : Rust (APEX-FSRS Crate), TypeScript (FSRS.js fallback), Insforge PostgreSQL
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
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Insforge.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.
