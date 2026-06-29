# SCY Forge — WDS-5 STRATEGIC CONTEXT
_Étape 05 — Copywriting & Tone of Voice_
_Source : `design-artifacts/D-UX-Design/*` + `minddoc/s00_design/scy_design_system.md`_
_Version : 1.0_

---

## 1. Résumé exécutif

**WDS-5** écrit le microcopy applicatif pour les 87 scénarios WDS-4 : labels, messages, erreurs, succès, placeholders, titres, sous-titres, tooltips, aria-labels.

### Principe directeur
> **Zéro friction.** L’utilisateur comprend ce qui se passe, ce qu’il peut faire, et ce qui va se passer après. Pas de jargon, pas de fausse promesse, pas de ambiguïté.

---

## 2. Tone of Voice SCY Forge

| Axe | Règle |
|-----|-------|
| **Clarté** | Phrases courtes (max 20 mots). Verbe d’action en tête. |
| **Précision** | Un message = une information. Pas de “et/ou” ambigu. |
| **Encouragement** | Feedback positif sans flatterie. “Bien joué” → “Session terminée”. |
| **Transparence** | Pas de “Erreur inconnue”. Toujours un motif clair + une action. |
| **Respect** | Pas de infantilisation, pas de hype. |

---

## 3.Lexique contrôlé

| Terme autorisé | Interdit |
|----------------|----------|
| Session, deck, carte, ingest, pipeline | Cours, leçon, chapitre |
| Réviser, valider, générer | Apprendre, réviser, étudier (sauf contexte) |
| Agent, chaîne, core | Robot, bot, assistant magique |
| Score, progression, streak | Niveau, grade, rang (sauf Arena) |
| Notification, alerte, rappel | Spam, push, buzz |

---

## 4. États de messages (pattern unique)

```
[Emoji optionnel] + [Verbe d’action] + [Contexte] + [Action]
```

### Succès
- `Session terminée : 12 cartes révisées`
- `Ingest complété : 140 documents prêts`
- `Pipeline #18 exécuté avec succès`

### Erreur
- `Impossible de traiter archive.zip : protection par mot de passe détectée`
- `Parser timeout (30s). [Réessayer] • [Voir le log]`

### Warning
- `Stockage à 92 %. Pensez à archiver vos anciens ingests.`
- `Pipeline en mode dégradé : Workers indisponibles`

### Info
- `Nouvelle version disponible : v2.4.1`
- `3 collaborateurs en attente d’invitation`

### Loading
- `Génération en cours… ~ 2 min`
- `Chargement du graphe conceptuel…`

---

## 5. Labels et boutons (par module)

### Auth
- `Se connecter`
- `Créer mon compte`
- `Mot de passe oublié ?`
- `Retour à la connexion`
- `Continuer`

### INGEST
- `Nouvel ingest`
- `Choisir une source`
- `Parcourir`
- `Lancer l’ingest`
- `Pause` / `Reprendre` / `Annuler`
- `Voir le résultat`

### NEURON
- `Déclarer un objectif`
- `Choisir le mode de génération`
- `Lancer la génération`
- `Valider le résultat`
- `Tout valider` / `Réviser manuellement`
- `Convertir en deck APEX`

### APEX
- `Nouvelle session`
- `Facile` / `Difficile` / `Oublié`
- `Montrer la réponse`
- `Session terminée`
- `Progression : 14/47 cartes`

### COSMOS
- `Visualiser`
- `Choisir une lentille`
- `Chronologique` / `Conceptuelle` / `Sociale` / `Pédagogique`
- `Ajouter un node`
- `Filtrer`
- `Exporter PNG`
- `Copier le lien`

### BRAIN
- `Poser une question`
- `Voir dans COSMOS`
- `Nouvelle discussion`

### ASCENT
- `Configurer un pipeline`
- `Ajouter un agent`
- `Lancer l’exécution`
- `Pause` / `Arrêter`
- `Voir les logs`
- `Relancer` / `Ignorer` / `Modifier la configuration`
- `Planifier`
- `Notifications : Slack / Email`

### B2B / Arena / Finance
- `Créer un espace équipe`
- `Inviter` / `Révoquer`
- `Rejoindre le défi`
- `Classement`
- `Synthèse financière`
- `Rapprochement`
- `Exporter le reporting`

### Settings / System
- `Enregistrer`
- `Prévisualiser`
- `Annuler`
- `Exporter` / `Importer`
- `Réessayer`
- `Basculer le thème`
- `Activer la double authentification`

---

## 6. Règles d’écriture

### Interdictions
- Jamais de tout en majuscules
- Jamais de point d’exclamation multiple
- Jamais de “!!! Alertes !!!”
- Jamais de jargon métier non validé
- Jamais de promesse chiffrée irréaliste

### Format dates / nombres
- Dates : `JJ/MM/AAAA` (FR) ou `MMM DD, AAAA` (EN) selon locale
- Durées : `~ 2 min`, `4h 12`, `en cours`
- Nombres : séparateur FR (espace) ou EN (virgule) selon locale
- Devise : `124 000 €` (espace insécable)

---

## 7. Accessibilité copy

- Tous les `aria-label` sont des phrases courtes en français
- Erreurs : `aria-describedby` pointe vers un ID accessible
- Toasts : `role="alert"` avec message concis
- Modales : `aria-labelledby` + `aria-describedby` optionnel

---

## 8. Traçabilité WDS-5

| Fichier | Phase | Rôle |
|---------|-------|------|
| `design-artifacts/D-UX-Design/batch-*-*.md` | WDS-4 | Scénarios UX sources |
| `design-artifacts/E-Copywriting/wds5-strategic-context.md` | WDS-5 | Tone + lexique |
| `design-artifacts/E-Copywriting/batch-*.md` | WDS-5 | Copy par scénario |

---

## 9. Roadmap WDS-5

```
WDS-5 — COPYWRITING
═══════════════════════════════════════════════════════════

 Phase            WDS Skill          Deliverable                     Statut
 ─────────────────────────────────────────────────────────────
 [TERMINÉ]    WDS-3 Scenarios      87 scénarios outlines            ✅
 [TERMINÉ]    WDS-4 UX Design      87 scénarios UX                 ✅
 [EN COURS]   WDS-5 Copywriting    wds5-strategic-context + 87 UX   🔄
 [À VENIR]    WDS-6 Assets         87 scenarios_assets.md           ⏳
 [TERMINÉ]    WDS-7 Design System  tokens + primitives              ✅
 [À VENIR]    WDS-8 Evolution      roadmap.md + hypotheses.md       ⏳
```
