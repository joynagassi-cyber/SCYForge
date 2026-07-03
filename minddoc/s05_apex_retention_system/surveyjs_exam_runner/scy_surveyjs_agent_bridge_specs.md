<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
APEX/FSRS en MVP simplifié. SMI Calculator gardé, scheduler complet différé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# Spécifications de Production — Pont Agentique SurveyJS & ASCENT UI
**Document ID** : SPEC-ASCENT-SURVEYJS-AGENT-BRIDGE  
**Date** : 2026-06-09  
**Statut** : DÉPLOYABLE (ZÉRO IMPROVISATION POUR LES ARCHITECTES & DÉVELOPPEURS)  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 🧭 Table des Matières
1. [Architecture Globale du Moteur de Génération Visuelle de Formulaires](#1-architecture-globale)
2. [Le Cœur Rust — Modèles de Données Typés de Validation (Zéro Illusion de Maîtrise)](#2-coeur-rust)
3. [L'Ingénierie de Prompt d'Élite pour l'Agent de Génération de Formulaires](#3-prompt-agent)
4. [Le Composant React TypeScript — L'Intégration SurveyJS UI](#4-react-integration)
5. [Le Moteur de Transition & Célébration (L'Effet Sensationnel)](#5-celebration-engine)

---

## 1. Architecture Globale du Moteur de Génération Visuelle de Formulaires {#1-architecture-globale}

Pour que l'évaluation finale et les quiz d'étapes deviennent une **expérience sensorielle, mémorable et scientifiquement rigoureuse**, nous concevons un pont direct entre l'agent d'orchestration (`AGENT-03` / `AGENT-09` / `AGENT-12` / `AGENT-13` utilisant notre proxy LiteLLM) et le runner front-end de la **Form Library de SurveyJS**.

L'agent IA ne se contente pas d'écrire du texte ; il manipule et compile un **modèle d'objet de formulaire** qui applique les lois de la charge cognitive (Sweller) et de la réduction d'anxiété (ACM 2025).

```
 ┌────────────────────────────────────────────────────────┐
 │            FLUX DE COMPILATION DE L'EXAMEN             │
 ├────────────────────────────────────────────────────────┤
 │                                                        │
 │  1. IA émet les questions (JSON brut structuré)        │
 │           │                                            │
 │           ▼                                            │
 │  2. Rust Parse & Validate (Structures Typées)          │
 │           │                                            │
 │           ▼                                            │
 │  3. `AGENT-12` (Visual-Critic) : Éradique les cycles   │
 │           │                                            │
 │           ▼                                            │
 │  4. `AGENT-13` (Cognitive-Validator) : Calibre à l'user │
 │           │                                            │
 │           ▼                                            │
 │  5. Client React reçoit le Schéma via WebSocket/GraphQL│
 │           │                                            │
 │           ▼                                            │
 │  6. Rendu instantané du runner SurveyJS (MIT)          │
 │                                                        │
 └────────────────────────────────────────────────────────┘
```

---

## 2. Le Cœur Rust — Modèles de Données Typés de Validation {#2-coeur-rust}

Pour assurer une sécurité et un typage stricts à la compilation, nous définissons les structures de données Rust modélisant fidèlement le schéma JSON attendu par SurveyJS. **Zéro JSON invalide envoyé au client.**

```rust
use serde::{Deserialize, Serialize};
use serde_json::Value;

/// Schéma racine d'un examen SurveyJS
#[derive(Serialize, Deserialize, Clone, Debug)]
#[serde(rename_all = "camelCase")]
pub struct SurveyJsSchema {
    pub title: String,
    pub description: Option<String>,
    pub show_progress_bar: String,         // Toujours "bottom" (Loi L1 - Séquençage)
    pub show_timer_panel: String,          // Toujours "top" (Silencieux et discret)
    pub max_time_to_finish: u32,           // Temps en secondes (Timer)
    pub show_timer_panel_mode: String,     // "all" ou "page"
    pub pages: Vec<SurveyPage>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct SurveyPage {
    pub name: String,
    pub elements: Vec<SurveyElement>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
#[serde(tag = "type", rename_all = "lowercase")]
pub enum SurveyElement {
    #[serde(rename_all = "camelCase")]
    Radiogroup {
        name: String,                      // ID technique de la question
        title: String,                     // La consigne (max 65ch)
        choices: Vec<SurveyChoice>,
        correct_answer: String,
        explanation: String,               // Feedback formatif de correction (DELTA)
    },
    #[serde(rename_all = "camelCase")]
    Comment {
        name: String,
        title: String,
        placeholder: Option<String>,
        max_length: u32,                   // Guide de saisie anti-anxiété
        explanation: String,
    },
    #[serde(rename_all = "camelCase")]
    Matrix {
        name: String,
        title: String,
        columns: Vec<SurveyChoice>,
        rows: Vec<SurveyChoice>,
        correct_matrix_answers: Value,     // Validation matricielle
        explanation: String,
    },
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct SurveyChoice {
    pub value: String,
    pub text: String,
}
```

---

## 3. L'Ingénierie de Prompt d'Élite pour l'Agent de Génération de Formulaires {#3-prompt-agent}

Voici l'invite système immuable injectée dans le modèle **DeepSeek V4/R1** par le backend Rust pour s'assurer que le contenu généré respecte à 100% les lois de la psychologie cognitive et de l'EdTech :

```
--- SYSTEM PROMPT : CONSEILLER PÉDAGOGIQUE ET CONCEPTEUR D'EXAMENS D'ÉLITE ---

Tu es le module de génération d'évaluations de SCY Forge. Ta mission est de générer un schéma JSON d'examen ou de quiz s'appuyant rigoureusement sur le format SurveyJS Form Library.

Tu dois impérativement appliquer les Lois de Psychologie Cognitive et les Standards Ergonomiques suivants :

1. LOI DE COGNITION (SWELLER) & CHUNKING :
   - Divise l'évaluation en plusieurs pages ("pages" array).
   - Maximum de DEUX (2) questions d'évaluation par page pour éviter la fatigue visuelle et libérer la mémoire de travail de l'apprenant.
   
2. LOI DU DOUBLE CODAGE & LISIBILITÉ (THE 65CH RULE) :
   - Les consignes de questions ("title") doivent être concises, claires et limitées à un maximum de 65 caractères de large par ligne sémantique.
   - S'il y a un énoncé de contexte long, insère-le séparément du champ de question de saisie.

3. SÉCURITÉ DE SAISIE & ANTI-ANXIÉTÉ :
   - Pour les questions textuelles ouvertes ("comment"), configure systématiquement un "maxLength" restrictif raisonnable (ex: 500 caractères).
   - Fournis un "placeholder" d'invite sémantique concret (ex: "Saisissez votre réponse ici. Longueur suggérée : ~50 mots.") pour guider la pensée et éliminer l'anxiété de la page blanche.

4. FEEDBACK FORMATIF D'ERREUR (DELTA AGENTS) :
   - Pour chaque question, fournis un champ "explanation" détaillé décrivant de manière positive, encourageante et rigoureuse POURQUOI la bonne réponse est vraie et comment la déduire à partir de la source du cours.

Tu dois impérativement retourner un JSON valide respectant la structure de schéma SurveyJS typée fournie. Ne retourne aucun commentaire textuel en dehors de la balise de bloc JSON.
```

---

## 4. Le Composant React TypeScript — L'Intégration SurveyJS UI {#4-react-integration}

Voici le code du composant d'affichage de production sous React 18, exploitant la **SurveyJS Form Library MIT** et intégrant l'index de navigation interactif (Minimap de formulaires) et le minuteur camouflé.

```typescript
import React, { useEffect, useMemo, useState } from 'react';
import { Model } from 'survey-core';
import { Survey } from 'survey-react-ui';
import 'survey-core/defaultV2.min.css';

// Thème de Production Adaptatif (Dark/Light) hérité des variables CSS globales de SCY Forge
const applyCosmosThemeToSurvey = (survey: Model, theme: 'dark' | 'light') => {
  const css = survey.css;
  if (theme === 'dark') {
    css.root = 'scy-survey-dark-root';
    css.question = {
      title: 'scy-survey-dark-q-title',
      description: 'scy-survey-dark-q-desc',
    };
  } else {
    css.root = 'scy-survey-light-root';
  }
};

interface SurveyJSFormRunnerProps {
  jsonSchema: any;
  userTheme: 'dark' | 'light';
  onExamComplete: (results: any, score: number) => void;
}

export const SurveyJSFormRunner: React.FC<SurveyJSFormRunnerProps> = ({
  jsonSchema,
  userTheme,
  onExamComplete,
}) => {
  const [activePage, setActivePage] = useState<number>(0);
  const [bookmarkedPages, setBookmarkedPages] = useState<Set<number>>(new Set());
  const [showTimer, setShowTimer] = useState<boolean>(false);

  // Instanciation unique et mémoïsée du modèle d'évaluation SurveyJS
  const surveyModel = useMemo(() => {
    const model = new Model(jsonSchema);
    
    // Configuration des standards anti-anxiété de SCY Forge
    model.showProgressBar = 'bottom';
    model.showTimerPanel = 'top';
    model.showTimerPanelMode = 'all'; // Afficher sur tout l'examen
    
    return model;
  }, [jsonSchema]);

  // Synchronisation du thème graphique de production
  useEffect(() => {
    applyCosmosThemeToSurvey(surveyModel, userTheme);
  }, [surveyModel, userTheme]);

  // Gestion des événements d'interactions sémantiques (EventBus ready)
  useEffect(() => {
    // Écoute du changement de page pour rafraîchir l'index de navigation latéral
    surveyModel.onCurrentPageChanged.add((sender) => {
      setActivePage(sender.currentPageNo);
    });

    // Événement de complétion de l'évaluation
    surveyModel.onComplete.add((sender) => {
      const results = sender.data;
      // Calcul déterministe du score local
      const score = calculateSmiExamScore(sender);
      onExamComplete(results, score);
    });
  }, [surveyModel, onExamComplete]);

  // Raccourci d'occultation du minuteur (Loi du contrôle perçu L7)
  const toggleTimerVisibility = () => {
    setShowTimer(!showTimer);
    surveyModel.showTimerPanel = showTimer ? 'top' : 'none';
  };

  // Ajout / Suppression de signets (Bookmark) pour la navigation de viewport
  const toggleBookmark = (pageIdx: number) => {
    const next = new Set(bookmarkedPages);
    if (next.has(pageIdx)) {
      next.delete(pageIdx);
    } else {
      next.add(pageIdx);
    }
    setBookmarkedPages(next);
  };

  return (
    <div className="scy-exam-workspace flex gap-6 w-full h-full p-6 bg-slate-950 text-slate-100 relative">
      {/* 🧭 NAVIGATION INDEX LATÉRAL (Le GPS de l'Examen) */}
      <div className="scy-exam-gps-index w-72 flex flex-col gap-4 p-4 rounded-xl border border-white/5 bg-white/[0.02] backdrop-blur-md">
        <h3 className="text-sm font-bold text-violet-400 tracking-wide uppercase">Index de l'Examen</h3>
        <p className="text-xs text-slate-400">Naviguez librement et marquez les questions d'un signet pour y revenir.</p>
        
        <div className="grid grid-cols-5 gap-2 mt-2">
          {surveyModel.pages.map((page, idx) => {
            const isCompleted = activePage > idx;
            const isActive = activePage === idx;
            const isBookmarked = bookmarkedPages.has(idx);
            
            return (
              <button
                key={page.name}
                onClick={() => { surveyModel.currentPageNo = idx; }}
                className={`w-10 h-10 rounded-lg flex items-center justify-center font-bold text-xs border transition-all ${
                  isActive 
                    ? 'bg-violet-600 border-violet-400 text-white shadow-lg shadow-violet-500/20 scale-105' 
                    : isBookmarked
                    ? 'bg-amber-500/20 border-amber-400 text-amber-300'
                    : isCompleted
                    ? 'bg-emerald-500/10 border-emerald-500/30 text-emerald-400'
                    : 'bg-white/5 border-white/5 text-slate-400 hover:bg-white/10'
                }`}
              >
                {isBookmarked ? '🔖' : idx + 1}
              </button>
            );
          })}
        </div>

        <button 
          onClick={() => toggleBookmark(activePage)}
          className="mt-auto btn flex items-center justify-center gap-2 py-2 text-xs border border-white/5 rounded-lg bg-white/5 hover:bg-white/10"
        >
          {bookmarkedPages.has(activePage) ? 'Retirer le signet' : '🔖 Marquer d\'un signet'}
        </button>
      </div>

      {/* 📄 LE RUNNER CENTRAL D'EXAMEN SURVEYJS */}
      <div className="scy-exam-runner-container flex-1 flex flex-col p-6 rounded-xl border border-white/5 bg-white/[0.01]">
        {/* Minuteur silencieux d'en-tête */}
        <div className="flex items-center justify-between pb-4 mb-4 border-b border-white/5">
          <div className="flex items-center gap-2 text-xs text-slate-400">
            <span>⏱️ Temps restant :</span>
            <button onClick={toggleTimerVisibility} className="text-violet-400 underline hover:text-violet-300">
              {showTimer ? "Masquer le minuteur" : "Afficher le minuteur"}
            </button>
          </div>
          <span className="text-xs font-semibold px-2 py-1 rounded bg-white/5 text-slate-300">
            Page {activePage + 1} de {surveyModel.pages.length}
          </span>
        </div>

        <div className="flex-1 max-w-[65ch] mx-auto w-full">
          <Survey model={surveyModel} />
        </div>
      </div>
    </div>
  );
};

// Fonction de calcul de score interne
function calculateSmiExamScore(survey: Model): number {
  let correctCount = 0;
  let totalCount = 0;
  
  survey.pages.forEach(page => {
    page.elements.forEach((el: any) => {
      if (el.correctAnswer) {
        totalCount++;
        if (survey.data[el.name] === el.correctAnswer) {
          correctCount++;
        }
      }
    });
  });
  
  return totalCount > 0 ? (correctCount / totalCount) * 100 : 100;
}
```

---

## 5. Le Moteur de Transition & Célébration (L'Effet Sensationnel) {#5-celebration-engine}

Pour faire de la complétion d'examen un moment inoubliable, la transition post-soumission applique un effet théâtralisé de révélation de réussite connectant instantanément l'`ENGAGEMENT-AMPLIFIER` (`AGENT-08`) et le radar d'SMI :

1. **La Phase de Révélation de Score (0 à 1.5s)** :
   - Un rideau s'affiche avec un effet de flou dynamique (`backdrop-filter: blur(20px)`). 
   - Une animation de compteur numérique fait défiler le score global obtenu jusqu'à sa valeur finale (ex: `84/100`), s'accompagnant d'un son d'impulsion harmonique doux de basse fréquence.
2. **Le Déploiement du Radar d'SMI (1.5s à 3s)** :
   - Le polygone de performance radar se déploie organiquement avec une transition d'expansion de taille à 60 FPS, montrant à l'apprenant l'impact exact de son examen sur les 5 dimensions de sa maîtrise.
3. **L'Animation Confetti Cognitive (Lois L7 - Motivation intrinsèque)** :
   - Des confettis géométriques de la couleur exacte de votre domaine de cursus s'éparpillent doucement à l'écran. 
   - L'agent `CHRONICLE` ou `AGENT-09` affiche un message de félicitations hautement personnalisé décrivant l'exploit de l'apprenant par rapport à sa baseline d'origine (ex: *"Jean-Baptiste, tu as conquis la compétence React Hooks ! Ton score d'Enseignement (D5) a progressé de +15 pts. Tu es prêt pour la certification finale."*).
