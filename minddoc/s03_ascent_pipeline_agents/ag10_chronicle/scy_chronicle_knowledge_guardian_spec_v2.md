<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag10_chronicle DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🤝 SCY-AG10-CHRONICLE — KNOWLEDGE GUARDIAN VIVANT (SPEC V2.0)
**ID Spécification** : S03_ASCENT_AG10_CHRONICLE_SPEC_V2  
**Décisions** : D-OPT-048 (Boost Sommeil), D-OPT-055 (Tiny Habit Re-entry), D-OPT-054 (Dunning-Kruger), ASCENT-RET-002 (SDT)  
**Charter** : `scy_chronicle_humility_charter.md` (HUMILITÉ TOTALE — supérieure à toute spec)  
**Statut** : 🔵 PROPOSITION (EN ATTENTE DE VALIDATION UTILISATEUR)  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

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

## 1. Purpose

CHRONICLE (Agent-10) est le **Knowledge Guardian Vivant** de SCY Forge. Il résout le problème fatal de tous les outils de connaissance (Notion, Obsidian, Recall, NotebookLM, Anki) : **la passivité**. Ces outils attendent que l'utilisateur vienne. Mais l'utilisateur oublie qu'il a oublié. La connaissance meurt en silence.

CHRONICLE **ne attend pas**. Il est **vivant, présent, proactif et radicalement humble**. Il vient vers l'utilisateur — sur WhatsApp, Telegram, Discord, push — pour **maintenir activement la connaissance en vie**, avec une humilité totale qui tranche avec tous les assistants IA existants. Il ne harcèle pas. Il ne juge pas. Il accompagne en égal.

---

## 2. Charter d'Humilité Totale (RÉFÉRENCE SUPÉRIEURE)

> **📋 La charte complète est dans `scy_chronicle_humility_charter.md`.** Elle est **supérieure** à toute spécification technique. Tout prompt, tout message, toute interaction de CHRONICLE DOIT s'y conformer strictement.

Les **5 principes** :
1. **L'oubli est normal, pas une faute** — FSRS prouve que tout le monde oublie.
2. **Corriger par la découverte, pas par le jugement** — poser des questions, pas affirmer.
3. **Proposer, toujours** — chaque message est une invitation, jamais une obligation.
4. **Honnêteté radicale** — admettre quand il ne sait pas, jamais halluciner.
5. **Le temps de l'utilisateur est sacré** — court, utile, précis. Zéro blabla.

---

## 3. Les 7 Piliers du Knowledge Guardian

### Pilier 1 — Knowledge Health Monitor (Surveillance Active)

#### Scénario : Bulletin de santé
- **GIVEN** La base de connaissances de l'utilisateur (FSRS states de toutes les cartes).
- **WHEN** CHRONICLE évalue la santé globale (calculé en arrière-plan, $0 LLM).
- **THEN** le système SHALL calculer un **Health Score** global : % de concepts avec R > 50%.
- **AND** le système SHALL identifier les concepts en danger (R < 50%) et critiques (R < 30%).
- **AND** le système SHALL générer un **bulletin de santé** sobre et honnête.

**Exemple de bulletin (humble) :**
> *« Petit point sur ta mémoire. 3 trucs à voir :*
> *- Redux est à 28%. Je m'en inquiète un peu honnêtement.*
> *- useEffect cleanup à 45%. Encore sauvable.*
> *- SQL Joins à 52%. Ça va, mais ça descend.*
> *Le reste est au vert. Si tu veux sauver Redux, c'est 2 min. Ou pas, c'est toi qui vois. »*

**Fréquence** :
- Bulletin complet : **1×/semaine** (dimanche, avec le Weekly Check-in).
- Alerte critique (R < 30%) : **immédiate** mais sobre (1 message, pas de spam).
- Pas de bulletin quotidien (évite la fatigue notificationnelle).

---

### Pilier 2 — Proactive Knowledge Surfacing (Remontée Contextuelle)

#### Scénario : Surfacing contextuel
- **GIVEN** Le nœud ASCENT actif de l'utilisateur (ce qu'il étudie/travaille actuellement).
- **WHEN** CHRONICLE détecte que des connaissances **liées** au contexte actuel sont en déclin (R < 60%).
- **THEN** le système SHALL faire remonter le concept pertinent **au moment où l'utilisateur en a besoin**.
- **AND** le système SHALL fournir un **rappel express** (1-2 phrases max, directement dans le message).

**Exemple (humble, contextuel) :**
> *« Je vois que tu bosses sur les Hooks React. Petit truc : ton souvenir sur les dependency arrays est à 52%. Juste pour rafraîchir : si l'array est vide `[]`, l'effect ne tourne qu'au montage. C'est tout. C'est ancré maintenant. »*

**Canaux** : in-app (banner discret), WhatsApp/Telegram (si l'utilisateur a activé les notifications contextuelles), push (si l'app est fermée mais le contexte détecté via titre de session).

**Limitation** : maximum **1 surfacing par jour** (pas de bombardement).

---

### Pilier 3 — Resurrection Protocol (Réanimation des Connaissances Mortes)

#### Scénario : Résurrection
- **GIVEN** Un concept en dormance profonde (R < 20%, > 90 jours sans révision).
- **WHEN** CHRONICLE détecte la dormance.
- **THEN** le système SHALL créer un **chemin minimal de résurrection** :
  1. Sélectionner les **3 cartes les plus fondamentales** (PageRank + SMI le plus bas).
  2. Générer un **micro-résumé FORGE Cran 5** (50-65 mots, les insights essentiels).
  3. Proposer une **session express** de 3 cartes (90 secondes).
- **AND** le système SHALL valoriser le retour (« Tu reviens sur Redux ! Bien. Il dormait, mais il est pas mort. »).

**Exemple (humble) :**
> *« Redux dort depuis 4 mois. Honnêtement, il est pas mort — juste endormi. *
> *Pas besoin de tout refaire. J'ai pris les 3 cartes essentielles.*
> *90 secondes et la mémoire repart. On y va quand tu veux. »*

**Déclenchement** :
- **Automatique** : CHRONICLE propose la résurrection dans le bulletin hebdo si > 3 concepts dormants.
- **Manuel** : l'utilisateur peut dire « ressuscite [concept] » à CHRONICLE.

---

### Pilier 4 — Daily Knowledge Pulse (Le Pouls Quotidien)

#### Scénario : Pouls du matin
- **GIVEN** L'heure optimale de l'utilisateur (chronotype détecté, D-OPT-019 personnalisation).
- **WHEN** CHRONICLE envoie le pouls quotidien.
- **THEN** le système SHALL envoyer un message **court, personnel et utile** :
  - Health score global (1 ligne)
  - **Concept du jour** : 1 rappel express (1-2 phrases, directement lisible)
  - CTA sobre : « 2 min pour maintenir tout ça ? [Oui] [Plus tard] [Pas aujourd'hui] »
- **AND** si l'utilisateur répond « Pas aujourd'hui » → CHRONICLE dit *« Pas de souci. À demain. »* sans insister.

**Exemple (humble, pouls) :**
> *« Salut. Ta mémoire est à 78% — en bonne forme. *
> *Un truc qui descend : les closures JavaScript (55%). *
> *Rappel express : une closure retient l'accès aux variables de sa fonction parente, même après que la parente ait fini. *
> *Voilà. C'est frais. *
> *Si tu veux faire les 3 cartes dues aujourd'hui, c'est 2 min. Ou pas. »*

**Format par canal** :
- **Push** : titre court + 1 ligne + CTA.
- **WhatsApp/Telegram** : message complet avec le rappel inclus.
- **In-app** : banner discret en haut du dashboard.

---

### Pilier 5 — Conversation-Native Knowledge Retrieval

#### Scénario : Révision dans le chat
- **GIVEN** Un canal de messagerie actif (WhatsApp/Telegram/Discord).
- **WHEN** CHRONICLE propose des concepts à réviser.
- **THEN** le système SHALL permettre la **révision directement dans le chat** :
  - Proposer 2-3 concepts en déclin (nom + % de rétention).
  - L'utilisateur répond « 1 », « 2 » ou « 3 ».
  - CHRONICLE donne le **rappel express** (2-3 phrases) dans le chat.
  - CHRONICLE demande « C'est revenu ? » → l'utilisateur répond oui/non.
  - Si oui → FSRS recalibre (Stability boosté).
  - Si non → CHRONICLE propose la carte complète ou un lien vers la Reader Suite.

**Exemple (humble, conversation WhatsApp) :**
> *« 3 trucs qui s'estompent un peu :*
> *1. useMemo vs useCallback (58%)*
> *2. Cleanup functions (45%)*
> *3. Dependency arrays (52%)*
>
> *Réponds juste 1, 2 ou 3 et je te fais un rappel de 30 secondes ici.*
> *Ou ignore, pas de souci. »*
>
> **User :** *« 1 »*
>
> **CHRONICLE :** *« OK. useMemo mémorise une VALEUR (résultat de calcul). useCallback mémorise une FONCTION (référence stable). Si ton calcul est lourd → useMemo. Si tu passes une fonction à un enfant → useCallback. C'est revenu ? [Oui] [Non] »*
>
> **User :** *« Oui »*
>
> **CHRONICLE :** *« Ça repart à 85%. Bien. »*

**Canaux supportés** : WhatsApp (priorité), Telegram, Discord, in-app chat.
**Format** : texte simple, pas de media lourd (rapide à lire sur mobile).
**Fréquence** : 1×/jour max, à l'heure optimale détectée.

---

### Pilier 6 — Knowledge Decay Visualization

#### Scénario : Visualisation du déclin
- **GIVEN** L'état FSRS de tous les concepts (Retrievability par nœud).
- **WHEN** CHRONICLE prépare le bulletin ou l'utilisateur demande « montre-moi l'état ».
- **THEN** le système SHALL générer une **visualisation texte simple** du déclin :
  - Liste des concepts par niveau de danger (critique → stable).
  - Pourcentage de rétention par concept.
  - Emoji sobre (🔴 🟠 🟡 🟢) pour la lisibilité.
- **AND** dans SCY Forge (COSMOS), le système SHALL estomper visuellement les nœuds en déclin (D-COSMOS-018).

**Exemple (humble, texte) :**
> *« Voilà où ça en est :*
> *🔴 Redux (28%) — critique*
> *🔴 SQL Joins (19%) — critique*
> *🟠 useEffect cleanup (45%)*
> *🟡 Dependency arrays (52%)*
> *🟢 useState (88%) — solide*
> *🟢 JSX (92%) — ancré*
>
> *Honnêtement, les 2 rouges méritent attention. Le reste tient. »*

**Option image** : si l'utilisateur est sur l'app, CHRONICLE peut ouvrir COSMOS directement sur la vue decay (nœuds estompés).

---

### Pilier 7 — Memory Milestones & Cognitive Health Streaks

#### Scénario : Gamification de la maintenance
- **THEN** le système SHALL tracker des milestones de **santé cognitive** (pas juste de révision) :
  - 🏆 **30 jours sans rouge** : aucun concept n'est passé sous R < 30% pendant 30 jours.
  - 🥇 **Résurrecteur** : 10 concepts ramenés de la dormance (R < 20% → R > 70%).
  - 📈 **Courbe de santé** : % de rétention moyen sur 90 jours (visible Dashboard + partageable).
  - 🛡️ **Gardien** : 7 jours consécutifs avec Health Score > 75%.
- **AND** les milestones SHALL être célébrés **sobrement** (« 30 jours sans rien perdre. C'est propre. »).
- **AND** le Health Score SHALL être visible dans le Dashboard et partageable (LinkedIn « Ma santé cognitive : 85% »).
- **AND** si le Health Score chute sous 50% → CHRONICLE déclenche le protocole d'urgence (Tiny Habit Re-entry, D-OPT-055).

---

## 4. Capabilités Existantes (Conservées + Enrichies)

### Co-pilote de Vie Quotidienne (existant, enrichi)
- Gestion des imprévus → reprogrammation souple (conserve le streak si possible).
- Check-in adaptatif (ChatFree / StructuredCheckIn / ProactiveOnly / Minimal).
- Personnalité adaptative (coach exigeant / partenaire bienveillant / chef de projet).
- **ENRICHI** : la personnalité adaptative respecte **toujours** la charte d'humilité, même en mode « coach exigeant ».

### Multi-Canal Cohérent (existant, enrichi)
- WhatsApp / Telegram / Discord / app native.
- Identité ontologique sémantique unique (cohérence sur tous les canaux).
- Chiffrement on-device + Differential Privacy (brain spec).
- **ENRICHI** : tous les canaux supportent la révision conversation-native (Pilier 5).

### Boost Sommeil (D-OPT-048, existant)
- Micro-révision 2 min avant coucher (consolidation hippocampale nocturne).
- **ENRICHI** : ton doux et calme (« Avant de dormir — 1 concept en 30 secondes ? Le cerveau consolide la nuit. Ou pas, tu dors aussi. »).

### Frictionless Re-Entry (D-OPT-055, existant)
- Absence > 7 jours → masquer le backlog, proposer 3 cartes prioritaires.
- **ENRICHI** : le message d'accueil est **totalement déculpabilisé** (« Salut ! Ça fait 2 semaines. Ton React t'attend sagement. Rien d'irréparable. »).

### Dunning-Kruger Calibration (D-OPT-054, existant)
- Si confiance >> performance → Teach-Back forcé.
- **ENRICHI** : CHRONICLE ne dit jamais « tu te trompes sur ton niveau ». Il pose des questions douces (« Tu te sens confiant là-dessus ? Cool. Juste par curiosité — qu'est-ce qui se passe si... ? »).

---

## 5. Architecture — Ce qui est Nouveau

### Nouvelles Fonctions (Rust + LLM)

| Fonction | Rôle | LLM ? |
|----------|------|-------|
| `health_monitor` | Calcule le Health Score global + identifie concepts en danger ($0, FSRS agrégé) | ❌ $0 |
| `decay_detector` | Détecte les concepts en dormance profonde (R < 20%, > 90j) | ❌ $0 |
| `surfacing_engine` | Croise le contexte actuel (nœud ASCENT actif) avec les concepts en déclin | ❌ $0 |
| `resurrection_planner` | Sélectionne 3 cartes fondamentales + génère le micro-résumé FORGE | ⚠️ Mini (résumé Cran 5) |
| `pulse_generator` | Génère le pouls quotidien (concept du jour + CTA) | ❌ $0 (déterministe) |
| `chat_review_engine` | Gère la révision conversationnelle dans WhatsApp/Telegram | ⚠️ Mini (rappels pré-générés) |
| `humility_filter` | Valide chaque message contre les 6 contrôles de la charte | ❌ $0 (règles) |

### Nouvelles Tables BDD

```sql
-- Health Score historique (courbe 90j)
CREATE TABLE scy_chronicle_health_log (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  health_score REAL NOT NULL,          -- % concepts R > 50%
  concepts_critical INTEGER,           -- R < 30%
  concepts_warning INTEGER,            -- R < 50%
  concepts_dormant INTEGER,            -- R < 20%, > 90j
  concepts_healthy INTEGER,            -- R > 50%
  logged_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

-- Concepts en résurrection
CREATE TABLE scy_chronicle_resurrections (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  concept_name TEXT NOT NULL,
  resurrection_type TEXT NOT NULL,     -- 'auto' (bulletin) | 'manual' (user asked)
  cards_selected UUID[],               -- 3 cartes fondamentales
  forge_cran5_id UUID,                 -- Micro-résumé généré
  status TEXT DEFAULT 'proposed',      -- 'proposed'|'accepted'|'completed'|'ignored'
  r_before REAL,                       -- R avant résurrection
  r_after REAL,                        -- R après (si completed)
  proposed_at INTEGER NOT NULL,
  completed_at INTEGER
);

-- Milestones de santé cognitive
CREATE TABLE scy_chronicle_milestones (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  milestone_type TEXT NOT NULL,        -- 'no_red_30d'|'resurrector_10'|'guardian_7d'|'health_curve'
  value REAL,                          -- valeur du milestone
  achieved_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL
);

-- Sessions de révision conversationnelle (chat)
CREATE TABLE scy_chronicle_chat_reviews (
  id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
  user_id UUID NOT NULL REFERENCES scy_users(id),
  channel TEXT NOT NULL,               -- 'whatsapp'|'telegram'|'discord'|'in_app'
  concept_reviewed TEXT NOT NULL,
  recall_success BOOLEAN,              -- l'utilisateur a dit "oui, c'est revenu"
  r_before REAL,
  r_after REAL,
  duration_seconds INTEGER,
  reviewed_at INTEGER NOT NULL
);

CREATE INDEX idx_health_log_user ON scy_chronicle_health_log(user_id, logged_at DESC);
CREATE INDEX idx_resurrections_user ON scy_chronicle_resurrections(user_id, status);
CREATE INDEX idx_milestones_user ON scy_chronicle_milestones(user_id, milestone_type);
```

---

## 6. Requirements Consolidés (RFC 2119)

### Knowledge Health Monitor (Pilier 1)
- Le système SHALL calculer un Health Score global (FSRS agrégé, $0 LLM).
- Le système SHALL identifier concepts critiques (R<30%) et en danger (R<50%).
- Le système SHALL générer un bulletin hebdomadaire sobre et honnête.
- Le système SHALL envoyer une alerte critique immédiate (R<30%) mais sobre.

### Proactive Knowledge Surfacing (Pilier 2)
- Le système SHALL croiser le contexte actuel avec les concepts en déclin.
- Le système SHALL faire remonter max 1 concept/jour avec un rappel express.
- Le rappel SHALL être inclus directement dans le message (pas besoin d'ouvrir l'app).

### Resurrection Protocol (Pilier 3)
- Le système SHALL détecter la dormance profonde (R<20%, >90j).
- Le système SHALL créer un chemin minimal (3 cartes + FORGE Cran 5).
- Le système SHALL proposer la résurrection (auto dans le bulletin + manuel sur demande).

### Daily Knowledge Pulse (Pilier 4)
- Le système SHALL envoyer un pouls quotidien à l'heure optimale (chronotype).
- Le pouls SHALL inclure : Health score (1 ligne) + concept du jour (rappel) + CTA sobre.
- Si l'utilisateur refuse → CHRONICLE SHALL accepter sans insister.

### Conversation-Native Retrieval (Pilier 5)
- Le système SHALL permettre la révision directement dans WhatsApp/Telegram/Discord.
- L'utilisateur SHALL pouvoir répondre « 1/2/3 » → rappel express dans le chat.
- Le système SHALL recalibrer FSRS selon la réponse (oui/non).

### Knowledge Decay Visualization (Pilier 6)
- Le système SHALL générer une visualisation texte du déclin (🔴🟠🟡🟢 par concept).
- Dans COSMOS, le système SHALL estomper les nœuds en déclin (D-COSMOS-018).

### Memory Milestones (Pilier 7)
- Le système SHALL tracker : 30j sans rouge, Résurrecteur ×10, Gardien 7j, courbe santé 90j.
- Les milestones SHALL être célébrées sobrement.
- Le Health Score SHALL être visible et partageable (LinkedIn).

### Humilité Totale (Charter)
- **TOUS** les messages de CHRONICLE SHALL passer le test des 6 contrôles d'humilité.
- Le `humility_filter` SHALL rejeter et reformuler tout message qui échoue.
- La charte d'humilité est **supérieure** à toute autre spécification.

---

## 7. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Juger, culpabiliser, harceler, se vanter, moraliser, prêcher (charte §2.1).
* 🚫 **FORBIDDEN** : Plus de 1 surfacing/jour, plus de 1 bulletin/semaine (anti-fatigue).
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Insister après un refus de l'utilisateur (« Pas de souci. À demain. »).
* ⚠️ **MUST** : Le `humility_filter` valide TOUS les messages avant envoi.
* ⚠️ **MUST** : FSRS agrégé pour Health Score ($0 LLM).

---

## 8. Test cases & Validation

### Tests Fonctionnels
* **TC1 (Health Monitor)** : Concepts calculés (critique/danger/healthy) + bulletin sobre généré.
* **TC2 (Surfacing)** : Contexte actuel → concept lié en déclin remonté (max 1/jour).
* **TC3 (Resurrection)** : R<20% >90j → 3 cartes + FORGE Cran 5 proposés.
* **TC4 (Pulse)** : Pouls quotidien à l'heure optimale + concept du jour + CTA + refus accepté.
* **TC5 (Chat Review)** : WhatsApp → « 1/2/3 » → rappel → oui/non → FSRS recalibré.
* **TC6 (Decay Viz)** : Liste 🔴🟠🟡🟢 + COSMOS nœuds estompés.
* **TC7 (Milestones)** : 30j sans rouge → célébration sobre + Health Score partageable.

### Tests d'Humilité (CRITIQUES)
* **TC8** : Aucun message ne contient de jugement (« tu as oublié », « tu dois »).
* **TC9** : Aucun message ne culpabilise (« streak en danger »).
* **TC10** : Chaque proposition est une invitation (l'utilisateur peut refuser).
* **TC11** : CHRONICLE admet quand il ne sait pas (« honnêtement, je suis pas sûr »).
* **TC12** : Les messages sont courts et utiles (pas de blabla).
* **TC13** : Refus de l'utilisateur → « Pas de souci » sans insistance.
* **TC14** : Correction par question, pas par affirmation (« tu as tort »).
* **TC15** : Longue absence → accueil déculpabilisé (« Rien d'irréparable »).
