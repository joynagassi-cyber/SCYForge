# Spécifications Psycho-Cognitives & Ergonomiques de Conception des Examens en Ligne
**Document ID** : SPEC-COGNITIVE-EXAM-DESIGN-V1  
**Date** : 2026-06-09  
**Statut** : SPÉCIFICATIONS TECHNIQUES DE PRODUCTION — EDTECH BEST PRACTICES  

---

## 🧭 Table des Matières
1. [Introduction : Psychologie Cognitive de l'Évaluation & Anxiété de Test](#1-introduction)
2. [Facteurs de Stress Visuels & UI (Stressors by Design)](#2-facteurs-de-stress)
3. [Spécifications UX/UI d'Évaluation pour Minimiser l'Anxiété & la Fatigue Mentale](#3-specifications-uxui)
4. [Mécanismes de Feedback Immédiat & Pédagogie Persuasive](#4-mecanismes-feedback)
5. [Standards Ergonomiques, Accessibilité & Choix Typographiques](#5-standards-ergonomiques)
6. [Matrice des "Reading Themes" Adaptatifs](#6-reading-themes)

---

## 1. Introduction : Psychologie Cognitive de l'Évaluation & Anxiété de Test {#1-introduction}

L'évaluation en ligne ne doit pas être une barrière d'anxiété. La recherche scientifique en psychologie cognitive montre que l'**Anxiété de Test (High Test Anxiety - HTA)** a un impact neurologique direct et destructeur sur les performances de l'apprenant :
* **Saturation de la Mémoire de Travail** : L'anxiété accapare et épuise les ressources d'attention et de contrôle cognitif descendants (top-down attention control) [4](https://www.sciencedirect.com/science/article/abs/pii/S0301051125000651). L'apprenant HTA montre une diminution de l'activité des ondes thêta neurales pendant la phase d'encodage [4](https://www.sciencedirect.com/science/article/abs/pii/S0301051125000651), limitant sa capacité à décoder des consignes longues ou denses [4](https://www.sciencedirect.com/science/article/abs/pii/S0301051125000651).
* **Théorie de la Charge Cognitive (Sweller)** : Pour évaluer rigoureusement la maîtrise sémantique réelle, l'interface doit **minimiser la charge cognitive extrinsèque** (le bruit visuel, l'anxiété liée à l'interface, la complexité de navigation) afin de libérer l'intégralité de la mémoire de travail pour la **charge cognitive intrinsèque** (la résolution de la question d'examen) [2](https://www.meazurelearning.com/resources/reducing-cognitive-load-and-test-anxiety-4-strategies-for-better-outcomes).

---

## 2. Facteurs de Stress Visuels & UI (Stressors by Design) {#2-facteurs-de-stress}

L'analyse de l'étude empirique de l'ACM (2025) *"Stress by Design? The Influence of Online Exam Interfaces on Student Anxiety"* montre que plusieurs choix de design d'interfaces classiques augmentent drastiquement l'anxiété [1](https://dl.acm.org/doi/10.1145/3743049.3748538) :
1. **Les grands champs de saisie vides (Large Blank Fields)** : Les espaces vides gigantesques pour les réponses textuelles intimident l'utilisateur, créant un sentiment d'incertitude quant à la longueur attendue de la réponse [1](https://dl.acm.org/doi/10.1145/3743049.3748538).
2. **La navigation rigide linéaire (Lock-Step Navigation)** : Empêcher l'utilisateur de naviguer librement, de sauter une question difficile pour y revenir plus tard ou de revoir ses réponses précédentes génère un sentiment d'enfermement et de stress [1](https://dl.acm.org/doi/10.1145/3743049.3748538).
3. **Le chronomètre omniprésent & sonore (Intrusive Timers)** : Un compte à rebours clignotant en rouge vif avec des alertes sonores ou des tic-tac détruit l'attention et génère une panique cognitive stérile [1](https://dl.acm.org/doi/10.1145/3743049.3748538).

---

## 3. Spécifications UX/UI d'Évaluation pour Minimiser l'Anxiété & la Fatigue Mentale {#3-specifications-uxui}

Pour neutraliser ces facteurs de stress et maximiser les performances cognitives réelles, les formulaires d'examens d'ASCENT et les questionnaires de SurveyJS appliquent les standards de conception suivants :

### A. Le Séquençage par Morceaux (Chunking & Grouping)
* **Principe** : Ne jamais afficher une liste infinie de questions sur une seule page. Les questions sont regroupées de manière thématique par sections courtes (max 3 questions par page) [1](https://dl.acm.org/doi/10.1145/3743049.3748538).
* **Visualisation** : Un indicateur de progression visuel horizontal (Stepper) montre la position de l'apprenant de manière rassurante et déterministe [1](https://github.com/surveyjs/survey-library).

### B. Les Champs de Saisie Structurés & Indicateurs de Longueur
* **Principe** : Remplacer les grandes zones de saisie intimidation par des champs de saisie segmentés ou délimités par des repères [1](https://dl.acm.org/doi/10.1145/3743049.3748538).
* **Implémentation** :
  * Utiliser un compteur de caractères dynamique indiquant la zone cible (ex: *"Longueur suggérée : ~150-300 mots. Actuel : 120 mots"*).
  * Afficher un placeholder d'invite sémantique dans le champ pour amorcer la pensée d'écriture de l'apprenant.

### C. La Navigation Flexible (Index de Viewport)
* **Principe** : L'apprenant doit se sentir en contrôle de son examen (Loi de l'Autonomie - Self-Determination Theory) [1](https://dl.acm.org/doi/10.1145/3743049.3748538).
* **Implémentation** : Un rail de navigation ou une grille miniature des questions est visible de manière persistante à gauche de l'examen :
  * Chaque case indique le statut de la question (Blanche = non vue, Bleue = répondue, Jaune = sautée).
  * **Option "Signet" (Bookmark Question)** : Permet à l'utilisateur de marquer une question difficile d'un drapeau jaune d'un simple clic pour y revenir en fin d'examen, éliminant le stress de blocage immédiat.

### D. Le Minuteur Silencieux & Camouflé (Silent Unobtrusive Timer)
* **Principe** : Le minuteur doit informer, pas stresser [1](https://dl.acm.org/doi/10.1145/3743049.3748538).
* **Implémentation** :
  * Le minuteur est affiché sous forme d'une fine ligne de progression de couleur neutre (gris/bleu discret) en haut de la page d'examen.
  * **Toggle d'affichage** : L'utilisateur peut masquer le chronomètre d'un simple clic (remplacé par une icône d'horloge discrète) pour se focaliser sur sa réflexion.
  * **Alerte de fin progressive** : Le minuteur ne clignote ou ne s'affiche en rouge qu'aux seuils critiques (ex: moins de 5 minutes restantes). **Zéro bruit, zéro bip sonore, zéro clignotement intempestif avant la fin [1](https://dl.acm.org/doi/10.1145/3743049.3748538).**

### E. Le Mode Simulation d'Échauffement (Assessment Sandbox)
* **Principe** : Éliminer la peur de l'outil et de la technique [2](https://www.meazurelearning.com/resources/reducing-cognitive-load-and-test-anxiety-4-strategies-for-better-outcomes).
* **Implémentation** : Avant de démarrer l'examen final (Gate 3), l'apprenant se voit proposer une micro-simulation d'échauffement de 2 questions sans enjeu de notation (Sandbox) [2](https://www.meazurelearning.com/resources/reducing-cognitive-load-and-test-anxiety-4-strategies-for-better-outcomes). Cela lui permet de se familiariser avec l'ergonomie, les boutons d'inputs et les raccourcis du formulaire d'évaluation [2](https://www.meazurelearning.com/resources/reducing-cognitive-load-and-test-anxiety-4-strategies-for-better-outcomes).

---

## 4. Mécanismes de Feedback Immédiat & Pédagogie Persuasive {#4-mecanismes-feedback}

La manière dont l'évaluation réagit à la réponse de l'utilisateur détermine son sentiment d'efficacité personnelle et sa rétention.

### A. Le Feedback Formatif Immédiat (On-the-fly Formative Feedback)
* **Principe** : L'erreur est une brique d'apprentissage, pas une punition.
* **Implémentation** : Lors des quiz de fin de nœuds d'étude, la validation d'une réponse incorrecte ne se solde pas par une croix rouge bête. Elle déclenche instantanément une **explication formative condensée** (générée par la chaîne DELTA) décrivant de manière encourageante *pourquoi* la réponse est fausse, avec un lien d'ancrage sémantique renvoyant au paragraphe précis du cours (Deep Link) [1](https://github.com/surveyjs/survey-library).

### B. Prompts d'Auto-Régulation Métacognitive (Self-Regulation Prompts)
* **Principe** : Renforcer l'évaluation par l'analyse de sa propre certitude (Métacognition active).
* **Implémentation** : Après avoir répondu à une question d'examen importante, le système affiche une jauge discrète : *"À quel point êtes-vous sûr de votre réponse ? (1 : Conjecture complète ──► 5 : Certitude absolue)"*.
  * Cette donnée est exploitée par l'`AGENT-05` pour calculer la dimension 4 du SMI (Justesse Métacognitive) et ajuster la stabilité FSRS de la carte mémoire associée.

---

## 5. Standards Ergonomiques, Accessibilité & Choix Typographiques {#5-standards-ergonomiques}

La clarté de lecture (Legibility & Readability) influe directement sur le confort de lecture et réduit drastiquement la fatigue visuelle lors des sessions d'évaluations denses [1](https://fiveable.me/introduction-to-visual-thinking/unit-7/legibility-readability-typography/study-guide/OPSkga1d5QMiEKOT).

### A. Le Font Stack Universel & Épuré
* **Principe** : Éviter les polices décoratives ou à empattements (serif) complexes pour le corps du texte d'examen.
* **Le Stack Recommandé** :
  ```css
  font-family: 'Inter Variable', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", sans-serif;
  ```
  * **Inter Variable** : Conçue spécifiquement pour la lisibilité sur écran d'ordinateur à petite échelle. Ses formes ouvertes de glyphes évitent la confusion de caractères (ex: distinguer le `1`, le `l` et le `I`).
  * **Noto Sans** : Pour le support universel Unicode des caractères internationaux (CJK, arabe, cyrillique) [D-QUAL-002].
  * **OpenDyslexic (Optionnel)** : Un interrupteur dans les paramètres d'accessibilité permet d'activer la police OpenDyslexic pour les personnes atteintes de troubles de la lecture [3](https://readabilitymatters.org/articles/research-highlight-therif).

### B. La Longueur de Ligne & Espacement (The 65ch Rule)
* **Longueur Maximale (Line Width)** : La scène centrale de texte ne doit **jamais dépasser 65 caractères de large (65ch)** [2](https://www.adoc-studio.app/blog/typography-guide). Une ligne trop large fatigue les muscles oculaires lors du retour à la ligne suivante, dégradant la concentration [1](https://fiveable.me/introduction-to-visual-thinking/unit-7/legibility-readability-typography/study-guide/OPSkga1d5QMiEKOT)[2](https://www.adoc-studio.app/blog/typography-guide).
* **Hauteur de ligne (Line-height)** : Doit être fixée à **1.5 ou 1.6** [2](https://www.adoc-studio.app/blog/typography-guide). Une hauteur inférieure compresse le texte, tandis qu'une hauteur supérieure éparpille la structure.
* **Espacement des paragraphes** : Fixé à `margin-bottom: 1.2em` pour séparer clairement les idées logiques.

---

## 6. Matrice des "Reading Themes" Adaptatifs {#6-reading-themes}

Inspiré des recherches d'Adobe Research (2023) sur la personnalisation de la lecture (*THERIF*), COSMOS et le moteur de cours d'ASCENT proposent **3 thèmes d'affichage adaptatifs** ajustables par l'utilisateur pour correspondre à son profil cognitif et à son niveau de fatigue [3](https://readabilitymatters.org/articles/research-highlight-therif) :

| Attribut Typographique | Thème "Compact" (Profil Rapide) | Thème "Open" (Consensus Général) | Thème "Relaxed" (Profil Dyslexie / Fatigue) |
|------------------------|----------------------------------|----------------------------------|---------------------------------------------|
| **Base Font-size** | 15px (0.93rem) | 16px (1rem) | 18px (1.125rem) |
| **Line-height** | 1.4 (densité sémantique) | 1.55 (confort optimal) | 1.7 (aéré) |
| **Letter-spacing** | -0.01em | Normal (0.01em) | 0.12em (inter-caractères étendu) [2] |
| **Max Content Width** | 60ch [2] | 65ch [2] | 70ch |
| **Usage suggéré** | Révision rapide, relecture diagonale. | Lecture standard par défaut. | Fatigue mentale élevée, dyslexie, confort de nuit. |
