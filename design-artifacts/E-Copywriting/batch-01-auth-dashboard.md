# SCY Forge — WDS-5 Copywriting — Batch 01 : Auth + Dashboard (SC-001 → SC-008)
_Phase WDS-5_
_Source UX : `design-artifacts/D-UX-Design/batch-01-auth-dashboard.md`_

---

## SC-001 — Connexion

| Élément | Copy |
|----------|------|
| Titre page | `Connexion` |
| Label email | `Email` |
| Label password | `Mot de passe` |
| Placeholder email | `vous@exemple.com` |
| Placeholder password | `••••••••` |
| CTA | `Se connecter` |
| Lien secondaire | `Mot de passe oublié ?` |
| Lien tertiaire | `Pas encore de compte ? S’inscrire` |
| Erreur générique | `Email ou mot de passe incorrect` |
| Erreur technique | `Service indisponible. Réessayez dans quelques instants.` |
| Succès (toast) | `Connexion réussie. Bienvenue.` |
| Aria-label toggle password | `Afficher le mot de passe` |

---

## SC-002 — Inscription

| Élément | Copy |
|----------|------|
| Titre page | `Créer un compte` |
| Label nom | `Nom complet` |
| Placeholder nom | `Jean Dupont` |
| Label email | `Email` |
| Placeholder email | `vous@exemple.com` |
| Label password | `Mot de passe` |
| Aide password | `8 caractères minimum` |
| CTA | `Créer mon compte` |
| Lien | `Déjà inscrit ? Se connecter` |
| Erreur nom | `Le nom est requis` |
| Erreur email | `Email invalide` |
| Erreur password | `Mot de passe trop court` |
| Succès | `Compte créé. Bienvenue.` |

---

## SC-003 — Onboarding — Premier objectif

| Élément | Copy |
|----------|------|
| Titre | `Bonjour 👋` |
| Sous-titre | `Personnalisons votre expérience en 30 secondes` |
| Label domaine | `Quel est votre domaine d’apprentissage ?` |
| Placeholder domaine | `Ex : Data, Frontend, Finance…` |
| Label niveau | `Niveau actuel` |
| Options | `Débutant` / `Intermédiaire` / `Avancé` |
| Label fréquence | `Rythme de rappel (optionnel)` |
| Options fréquence | `Quotidien` / `Hebdomadaire` / `Personnalisé` |
| CTA | `Continuer` |
| Bouton secondaire | `Passer` |
| Erreur domaine | `Indiquez au moins un domaine` |
| Tooltip | `Vous pourrez modifier ces paramètres à tout moment.` |

---

## SC-004 — Mot de passe oublié

| Élément | Copy |
|----------|------|
| Titre | `Réinitialiser votre mot de passe` |
| Description | `Nous vous enverrons un lien pour réinitialiser votre mot de passe.` |
| Label email | `Email` |
| Placeholder email | `vous@exemple.com` |
| CTA | `Envoyer le lien` |
| Lien | `Retour à la connexion` |
| Succès | `Email envoyé. Vérifiez votre boîte de réception.` |
| Erreur | `Aucun compte associé à cet email.` |

---

## SC-005 — Dashboard — Vue d’ensemble

| Élément | Copy |
|----------|------|
| Titre section | `Bonjour, Jean` |
| Sous-titre | `Prêt à reprendre ?` |
| Widget session | `Session du jour` |
| Sous-widget session | `3 decks • 12 cartes` |
| CTA session | `Reprendre` |
| Widget progression | `Progression hebdo` |
| Sous-widget progression | `68 % • 3 sessions` |
| Widget activité | `Activité 7 jours` |

---

## SC-006 — Dashboard — Personnalisation

| Élément | Copy |
|----------|------|
| Titre | `Personnaliser le dashboard` |
| Description | `Ajoutez, réorganisez ou supprimez des widgets.` |
| CTA ajout | `+ Ajouter un widget` |
| Label recherche widgets | `Rechercher un widget…` |
| Actions | `Déplacer` / `Supprimer` / `Ajouter` |

---

## SC-007 — Navigation cross-module

| Élément | Copy |
|----------|------|
| Label recherche | `Rechercher… (⌘K)` |
| Placeholder | `Modules, decks, documents…` |
| Rés vide | `Aucun résultat pour « {query} »` |
| Item INGEST | `Nouvel ingest` |
| Item APEX | `Session de révision` |
| Item COSMOS | `Visualiser` |
| Item BRAIN | `Nouvelle discussion` |
| Item ASCENT | `Pipelines` |

---

## SC-008 — État vide / fallback

| Élément | Copy |
|----------|------|
| Titre vide | `Aucune activité récente` |
| Description | `Commencez par un ingest ou une génération NEURON.` |
| CTA primaire | `Nouvel ingest` |
| CTA secondaire | `Découvrir les modes COSMOS` |
| Titre erreur | `Impossible de charger le dashboard` |
| Description erreur | `Vérifiez votre connexion ou réessayez.` |
| CTA erreur | `Réessayer` |

---

## Traçabilité WDS-5

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../D-UX-Design/batch-01-auth-dashboard.md` | WDS-4 | UX source SC-001→SC-008 |
| `.../E-Copywriting/batch-01-auth-dashboard.md` | WDS-5 | Copy associé |
