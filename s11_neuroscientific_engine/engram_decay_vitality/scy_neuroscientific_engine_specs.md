# 🧠 LE MOTEUR NEUROSCIENTIFIQUE DE MINDFORGE — SPÉCIFICATIONS TECHNIQUES
## Architecture d'Ingénierie Biologique de l'Apprentissage : ENGRAM, Compétition Synaptique, Protocole FORGE, Mode FRICTION et Carte Thermique

**Document ID** : SPEC-SCY-NEUROSCIENTIFIC-ENGINE-V1.0  
**Date** : 2026-06-12  
**Statut** : 🟢 SPÉCIFICATION STRATÉGIQUE DE PRODUCTION  
**Périmètre** : Implémentation des 5 piliers neurocognitifs validés empiriquement au sein du moteur hybride (Rust Axum & Mastra TS).  
**Stack de Référence** : Rust Core (Mathématiques & Vecteurs) + Mastra TypeScript (Orchestration & UI) + Northflank PostgreSQL + Zilliz Cloud Serverless

---

## 🧭 Table des Matières
1. [Vision Architecturale : Le Premier Second Brain Biologiquement Cohérent](#1-vision)
2. [Pilier 1 : Le Système ENGRAM (Dormance & Cold Engram Store)](#2-engram)
3. [Pilier 2 : Le Moteur de Sélection par Activation (Compétition Synaptique)](#3-competition)
4. [Pilier 3 : Le Protocole FORGE (L'Effet de Génération obligatoire)](#4-forge)
5. [Pilier 4 : Le Mode FRICTION (Interleaving Intelligent & Anti-Fluidité)](#5-friction)
6. [Pilier 5 : La Carte Thermique du Graphe (Thermodynamique Entropique)](#6-thermal)
7. [Schémas de Base de Données Unifiés (Northflank PostgreSQL)](#7-db-schema)
8. [Orchestration Backend (Mastra Workflows & Rust Axum APIs)](#8-orchestration)

---

## 1. Vision Architecturale : Le Premier Second Brain Biologiquement Cohérent {#1-vision}

La quasi-totalité des outils de gestion des connaissances actuels (PKM) traitent la mémoire comme un **disque dur statique** : accumuler des notes, stocker des fichiers dans des dossiers, et relier des liens hypertextes. Mais le cerveau humain ne fonctionne pas ainsi. C'est une structure plastique vivante, soumise à des contraintes de ressources d'énergie, où **l'oubli est un mécanisme actif d'optimisation**, où la **difficulté est une condition d'ancrage**, et où la **récupération sélective modifie et sculpte continuellement la topographie du réseau synaptique**.

SCY Forge n'est pas un Second Brain passif. C'est un **système d'apprentissage actif cybernétique** aligné sur le fonctionnement biologique du cerveau. Ce document d'ingénierie détaille l'implémentation logicielle des 5 lois cognitives fondamentales validées empiriquement au cœur de la stack hybride SCY Forge.

---

## 2. Pilier 1 : Le Système ENGRAM (Dormance & Cold Engram Store) {#2-engram}

### A. La Base Scientifique (Molecular Psychiatry 2024)
L'oubli actif est un processus biologique actif contrôlé par des cellules dopaminergiques et microgliales. Il permet de libérer des ressources d'attention et d'accroître la flexibilité comportementale en effaçant les détails bruyants.

### B. Spécification Technique SCY Forge
Chaque nœud d'apprentissage (concept dans COSMOS ou nœud de cours dans ASCENT) se voit attribuer un **score de vitalité** dynamique $V \in [0, 100]$.

#### L'Équation de Vitalité Synaptique :
$$V(t) = w_r \cdot R(t) + w_c \cdot C(t) + w_m \cdot M(t) - \lambda \cdot (t - t_{\text{last}})$$

Où :
* $R(t) \in [0, 100]$ : Score de rétention issu des révisions espacées **APEX (FSRS 5.0)**.
* $C(t) \in [0, 100]$ : Centralité de degré normalisée du concept dans le graphe global (densité de connexions actives).
* $M(t) \in [0, 100]$ : Score de mobilisation récente (si le concept a été cité dans des notes, interrogé dans BRAIN, ou mobilisé dans l'ARENA sur les 7 derniers jours).
* $\lambda \in \mathbb{R}^+$ : Facteur de décomposition/déclin biologique.
* $(t - t_{\text{last}})$ : Temps écoulé en jours depuis la dernière interaction active.

#### Entrée en Dormance (Cold Engram Vault) :
Dès que $V(t) < V_{\text{dormance}}$ (seuil fixé par défaut à **20/100**) :
1. Le nœud est retiré du graphe sémantique actif et masqué de l'interface par défaut (COSMOS).
2. Il est exclu des requêtes RAG par défaut de BRAIN pour assainir le contexte et éviter le bruit sémantique.
3. Il est transféré vers la table froide `scy_engram_vault`.

#### Résurrection Active obligatoire :
Pour réactiver un nœud en dormance, l'utilisateur ne peut pas cliquer sur un simple bouton "Restaurer". Il doit soumettre une **tentative de reconstruction active** :
- Le système présente uniquement 3 mots-clés contextuels de l'engram.
- L'utilisateur doit rédiger un court texte libre ou un résumé conceptuel de ce qu'il en retient.
- L'APEX-AGENT en Rust évalue la réponse sémantiquement. Si la similarité conceptuelle dépasse **70%**, le nœud réintègre le graphe actif avec un score de vitalité restauré à **50**. Sinon, la dormance est maintenue et des indices supplémentaires lui sont présentés.

---

## 3. Pilier 2 : Le Moteur de Sélection par Activation (Compétition Synaptique) {#3-competition}

### A. La Base Scientifique (Retrieval-Induced Forgetting - RIF)
La récupération sélective d'une information facilite son rappel ultérieur, mais déclenche un mécanisme d'inhibition compétitive qui provoque l'oubli actif des souvenirs connexes non récupérés associés au même indice.

### B. Spécification Technique SCY Forge
Lorsqu'un utilisateur réactive avec succès un nœud cible $N_i$ (par exemple en l'utilisant dans une session pratique ARENA ou en le citant dans ses notes), SCY Forge applique un **algorithme de suppression compétitive** à ses nœuds adjacents (1-hop) dans le graphe.

#### L'Algorithme de Suppression Compétitive (Rust Engine) :
```rust
// backend_rust/src/neurochain/algorithms/synaptic_competition.rs
use uuid::Uuid;

pub struct ConceptNode {
    pub id: Uuid,
    pub vitality_score: f32,
    pub embedding: Vec<f32>,
}

pub fn apply_retrieval_induced_forgetting(
    activated_node: &ConceptNode,
    neighbors: &mut Vec<ConceptNode>,
    suppression_factor: f32, // par défaut 0.12 (α)
) {
    for neighbor in neighbors.iter_mut() {
        // Calculer la similarité cosinus sémantique entre les concepts (Tension compétitive)
        let similarity = cosine_similarity(&activated_node.embedding, &neighbor.embedding);
        
        if similarity > 0.65 {
            // Plus ils sont sémantiquement proches, plus la compétition pour l'attention est forte
            let suppression_delta = suppression_factor * similarity * neighbor.vitality_score;
            neighbor.vitality_score = (neighbor.vitality_score - suppression_delta).max(0.0);
            
            // Log de transition synaptique pour l'observabilité
            log_synaptic_pruning(activated_node.id, neighbor.id, suppression_delta);
        }
    }
}

fn cosine_similarity(a: &[f32], b: &[f32]) -> f32 {
    let dot_product: f32 = a.iter().zip(b.iter()).map(|(x, y)| x * y).sum();
    let norm_a: f32 = a.iter().map(|x| x * x).sum::<f32>().sqrt();
    let norm_b: f32 = b.iter().map(|x| x * x).sum::<f32>().sqrt();
    dot_product / (norm_a * norm_b)
}
```

#### Effet Graphique :
Le graphe se "taille" dynamiquement à l'usage. Les liaisons redondantes ou inutilisées s'étiolent de manière compétitive, faisant émerger une structure de connaissances élancée, robuste et exempte de surcharge.

---

## 4. Pilier 3 : Le Protocole FORGE (L'Effet de Génération obligatoire) {#4-forge}

### A. La Base Scientifique (Science 2011 / Effect size d = 0.40)
Forcer le cerveau à générer une information ou à prédire un résultat *avant* de lui en révéler la solution crée une "difficulté désirable" qui triple le taux de mémorisation à long terme et décuple la création de connexions synaptiques (LTP).

### B. Spécification Technique SCY Forge
Le **Protocole FORGE** interdit l'affichage passif de tout contenu éducatif (Knowledge Cards d'ASCENT ou documents synthétisés en Mode Normal) sans une tentative préalable de génération de la part de l'utilisateur.

```
                    [ L'UTILISATEUR SÉLECTIONNE UN NŒUD DE COURS ]
                                          │
                                          ▼
                      [ LE PROTOCOLE FORGE S'ACTIVE (Bypass) ]
               Masquage du texte complet. Génération d'une amorce :
                 ├── 1. Cloze Test (Texte à trous conceptuel)
                 ├── 2. Prediction Challenge (Prédire la mécanique)
                 └── 3. Feynman Sketch (Écrire 1 phrase explicative)
                                          │
                                          ▼
                      [ TENTATIVE DE GÉNÉRATION DE L'UTILISATEUR ]
                                          │
                        ┌─────────────────┴─────────────────┐
                        ▼ [Correcte ou Incorrecte]          ▼ [Abandon/Je ne sais pas]
                   Score calculé                      Révélation avec 
                   (Dopamine Release)                 mousse cognitive
                        │                                   │
                        └─────────────────┬─────────────────┘
                                          ▼
                   [ RÉVÉLATION COMPLÈTE DU CONTENU ET DE KATEX ]
```

#### Exemple de composant d'Amorce React (Mastra API driven) :
```typescript
// components/ForgeProtocolGate.tsx
import React, { useState } from 'react';
import { Sparkles, Zap } from 'lucide-react';

export const ForgeProtocolGate = ({ nodeId, rawPrerequisites, onUnlock }) => {
  const [userAttempt, setUserAttempt] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorFeedback, setErrorFeedback] = useState('');

  const handleForgeAttempt = async () => {
    setIsSubmitting(true);
    try {
      const res = await fetch('/api/neuroscience/forge/attempt', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nodeId, attempt: userAttempt }),
      });
      const data = await res.json();
      
      if (data.success || data.allowUnlock) {
        onUnlock(); // Débloque l'accès aux cartes complètes
      } else {
        setErrorFeedback(data.feedback);
      }
    } catch {
      setErrorFeedback("Erreur de communication avec le moteur d'évaluation.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="p-8 bg-[#0D0D15] border border-[#D97706]/40 rounded-xl max-w-2xl mx-auto shadow-2xl">
      <div className="flex items-center gap-3 mb-4">
        <Zap className="text-[#D97706] animate-pulse" />
        <h3 className="text-xl font-bold text-white tracking-wide uppercase">Protocole FORGE — Effort de Génération</h3>
      </div>
      <p className="text-gray-300 text-sm mb-6 leading-relaxed">
        Avant de révéler la connaissance complète, stimule ton cortex préfrontal. 
        En t'appuyant sur tes prérequis : <span className="text-[#D97706] font-semibold">{rawPrerequisites}</span>, 
        explique en tes propres termes comment fonctionne ce concept ou prédis sa structure logique :
      </p>
      
      <textarea
        className="w-full h-32 p-4 bg-[#05050A] text-white border border-gray-800 rounded-lg focus:border-[#D97706] focus:outline-none text-sm transition-colors mb-4"
        placeholder="Rédige ton hypothèse en une ou deux phrases..."
        value={userAttempt}
        onChange={(e) => setUserAttempt(e.target.value)}
      />
      
      <button
        onClick={handleForgeAttempt}
        disabled={isSubmitting || !userAttempt.trim()}
        className="px-6 py-3 bg-gradient-to-r from-[#D97706] to-[#B45309] hover:from-[#F59E0B] hover:to-[#D97706] text-black font-bold text-sm tracking-widest rounded-lg flex items-center gap-2 transition-all disabled:opacity-50"
      >
        <Sparkles size={16} /> FORGER LA CONNAISSANCE
      </button>
      
      {errorFeedback && <p className="mt-4 text-[#D97706] text-xs leading-relaxed italic">{errorFeedback}</p>}
    </div>
  );
};
```

---

## 5. Pilier 4 : Le Mode FRICTION (Interleaving Intelligent & Anti-Fluidité) {#5-friction}

### A. La Base Scientifique (Bjork 1994)
La sensation de fluidité et d'aisance pendant l'apprentissage est une illusion trompeuse. Les méthodes d'études fluides (comme réviser le même sujet d'affilée en blocs) maximisent les performances à court terme mais mènent à un oubli massif. À l'inverse, l'entrelacement des domaines (Interleaving) et l'anti-fluidité doublent la rétention réelle lors des évaluations différées.

### B. Spécification Technique SCY Forge : Le "Mode FRICTION"
Le Mode FRICTION est un commutateur d'interface et d'algorithme activé par défaut.

1. **Interleaving Scheduling (Entrelacement cognitif)** :
   - Lorsque l'utilisateur lance une révision ou un apprentissage sur un domaine cible, l'algorithme ne lui présente pas 100% de ce domaine.
   - Il compose la session avec **70% du domaine ciblé** et **30% de domaines connexes ou déjà maîtrisés** (choisis pour créer une dissonance productive).
2. **Interface Anti-Fluidité (U-UX Design)** :
   - **Masquage des Métriques de Progression** : Aucun indicateur de progression en temps réel (XP bar, pourcentage complété) n'est affiché pendant la phase d'apprentissage active. Voir son score monter crée de la "fluidité perçue" artificielle et diminue l'effort synaptique.
   - **Reflection Delay** : Lors des quiz, le bouton "Vérifier la réponse" est verrouillé par un minuteur silencieux de **3 secondes**. L'utilisateur est forcé de s'arrêter pour faire face au problème avant d'avoir accès à la validation, stimulant l'introspection.
   - **Mélange de formats visuels** : L'affichage alterne brutalement entre une vue textuelle, une vue conceptuelle COSMOS, et une équation LaTeX pour briser l'habituation cognitive du cortex visuel.

---

## 6. Pilier 5 : La Carte Thermique du Graphe (Thermodynamique Entropique) {#6-thermal}

### A. La Base Scientifique (Zep / Knowledge Temperature 2025)
La mémoire de travail d'un agent ou d'un utilisateur évolue dans un repère thermodynamique. Le niveau de consolidation se modélise par une "température" où l'entropie s'accroît à mesure que l'information se décompose dans le temps sans réactivation.

### B. Spécification Technique SCY Forge
Nous implémentons une visualisation WebGL tridimensionnelle de la **Carte Thermique du Graphe** (COSMOS Mode 26). La température thermique $T_n$ de chaque concept est recalculée à chaque modification :

#### L'Équation Thermodynamique du Nœud :
$$T_n(t) = \alpha \cdot \text{Vitality}(t) + \beta \cdot \left| \frac{\partial H}{\partial t} \right|$$

Où :
- $\text{Vitality}(t)$ : Score de vitalité du Pilier 1.
- $\left| \frac{\partial H}{\partial t} \right|$ : Taux de variation récent de l'entropie structurelle du nœud (mesurant l'intensité et la vitesse de nouvelles relations créées par **Graphiti**).

#### Code Visuel de COSMOS Mode 26 :
* **🟢 Hot Zone (Ambre/Or `#D97706`)** : Concept en cours d'étude active, forte entropie, consolidation rapide. Le nœud "pulse" et rayonne.
* **🔵 Warm Zone (Bleu Nuit `#0D0D15` à Violet)** : Concept stable, mémorisation consolidée, structure saine.
* **❄️ Cold Zone (Gris Ardoise / Frozen Silver)** : Concept inactif, en danger d'oubli imminent. Le nœud s'estompe visuellement et se rapproche de l'entrée dans l'**ENGRAM Vault**.

---

## 7. Schémas de Base de Données Unifiés (Northflank PostgreSQL) {#7-db-schema}

Le moteur neuroscientifique s'appuie sur ces tables hautement structurées sur **Northflank PostgreSQL** :

```sql
-- == TABLE CENTRALISÉE DE VITALITÉ SYNAPTIQUE ==
CREATE TABLE scy_synaptic_vitality (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    node_id         UUID NOT NULL,        -- Référence polymorphique à scy_ascent_nodes ou scy_concepts
    node_type       TEXT NOT NULL,        -- 'ascent_node' | 'concept'
    
    -- Composantes d'évaluation
    retention_score REAL DEFAULT 100.0,   -- FSRS 5.0
    connection_score REAL DEFAULT 0.0,    -- Degré de centralité dans Graphiti
    mobilization_score REAL DEFAULT 0.0,  -- Mention récente dans notes/chats
    
    vitality_score  REAL DEFAULT 100.0,   -- Résultat de l'équation de vitalité (0-100)
    temperature     REAL DEFAULT 50.0,    -- Température thermodynamique
    
    last_interaction_at INTEGER NOT NULL,
    updated_at      INTEGER NOT NULL
);

-- == COLD ENGRAM VAULT (ARCHIVAGE ACTIF) ==
CREATE TABLE scy_engram_vault (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    node_id         UUID NOT NULL,
    title           TEXT NOT NULL,
    content_payload JSONB NOT NULL,       -- Sauvegarde de la Knowledge Card complète compressée
    keywords        TEXT[] NOT NULL,      -- Clés de reconstruction pour la résurrection
    dormant_since   INTEGER NOT NULL,
    attempts_count  INTEGER DEFAULT 0
);

-- == PROTOCOLE FORGE (TENTATIVES DE GÉNÉRATION) ==
CREATE TABLE scy_forge_attempts (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    node_id         UUID NOT NULL,
    attempt_text    TEXT NOT NULL,
    semantic_score  REAL NOT NULL,        -- Score calculé par APEX-AGENT (similarité conceptuelle)
    is_unlocked     BOOLEAN DEFAULT false,
    created_at      INTEGER NOT NULL
);

-- == JOURNAL DE PRUNING COMPÉTITIF (RIF) ==
CREATE TABLE scy_synaptic_pruning_log (
    id              UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id         UUID NOT NULL REFERENCES scy_users(id),
    activated_node_id UUID NOT NULL,
    suppressed_node_id UUID NOT NULL,
    suppression_delta REAL NOT NULL,
    created_at      INTEGER NOT NULL
);

-- Index pour calculs de température en tâche de fond
CREATE INDEX idx_vitality_user_score ON scy_synaptic_vitality(user_id, vitality_score);
CREATE INDEX idx_engram_user_dormant ON scy_engram_vault(user_id, dormant_since);
CREATE INDEX idx_forge_user_node ON scy_forge_attempts(user_id, node_id);
```

---

## 8. Orchestration Backend (Mastra Workflows & Rust Axum APIs) {#8-orchestration}

L'orchestration de ces processus est distribuée entre la couche asynchrone de Mastra et le moteur d'évaluation haute-performance de Rust.

### 8.1 API Rust d'Évaluation de la Résurrection / Tentative FORGE
Le service Rust Axum fournit l'évaluation sémantique ultra-rapide des saisies utilisateur en s'appuyant sur des modèles locaux :

```rust
// backend_rust/src/routes/neuroscience.rs
use axum::{routing::post, Json, Router};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Deserialize)]
pub struct ForgeAttemptRequest {
    pub user_id: Uuid,
    pub node_id: Uuid,
    pub attempt_text: String,
}

#[derive(Debug, Serialize)]
pub struct ForgeAttemptResponse {
    pub score: f32,             // Similarité sémantique (0.0 - 1.0)
    pub allow_unlock: bool,     // Vrai si score >= 0.70 ou si effort suffisant
    pub feedback: String,       // Explication pédagogique socratique d'APEX-AGENT
}

pub fn router() -> Router {
    Router::new()
        .route("/api/neuroscience/forge/attempt", post(handle_forge_attempt))
}

async fn handle_forge_attempt(
    Json(payload): Json<ForgeAttemptRequest>,
) -> Json<ForgeAttemptResponse> {
    // 1. Récupérer le contenu de référence du nœud en base PostgreSQL
    // 2. Calculer la similarité cosinus avec l'embedding de l'attempt_text (Candle local)
    // 3. Déduire le score et générer un court feedback socratique d'encouragement
    let score = 0.78; // Valeur exemple calculée sémantiquement
    let allow_unlock = score >= 0.70;
    
    Json(ForgeAttemptResponse {
        score,
        allow_unlock,
        feedback: "Félicitations. Ton hypothèse capture 78% de la mécanique réelle de l'Auto-Attention. Tu as correctement identifié l'interaction Query-Key.".to_string(),
    })
}
```

### 8.2 Workflow Mastra d'Onboarding et Adaptabilité
Le workflow de Mastra (TypeScript) intègre de manière native l'entrelacement (Interleaving) du Mode Friction lors de la sélection d'une session :

```typescript
// backend_ts/src/normal_pipeline/steps/getFrictionSession.ts
import { Step } from '@mastra/core';

export const getFrictionSessionStep = new Step({
  id: 'get-friction-session',
  execute: async ({ context }) => {
    // 1. Récupérer les 70% de cartes/contenus du domaine ciblé
    const targetCards = await db.getCardsForDomain(context.domainId, 7);
    
    // 2. Identifier et charger 30% de cartes de domaines éloignés ou consolidés
    const interleavedCards = await db.getInterleavedCardsForUser(context.userId, 3);
    
    // 3. Fusionner et mélanger les cartes (casser la fluidité de progression)
    const sessionCards = shuffleArray([...targetCards, ...interleavedCards]);
    
    return {
      sessionCards,
      frictionModeActive: true,
      hideProgressMetrics: true // Force l'UI à masquer les barres de progression
    };
  }
});

function shuffleArray(array: any[]) {
  return array.sort(() => Math.random() - 0.5);
}
```

---

## 🏁 Conclusion : Une Identité Révolutionnaire

En implémentant ces **5 spécifications neuroscientifiques directes**, SCY Forge s'arrache définitivement de la catégorie des clones simples de Second Brain. Le système devient une **extension vivante et plastique de la cognition de l'utilisateur**, le guidant par l'anti-fluidité vers une mémorisation indestructible, tout en gérant de manière saine, transparente et automatisée, le cycle naturel de la vie et de la mort de ses connaissances.
