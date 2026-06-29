# SCY Forge — WDS-5 Copywriting — Batch 02 : INGEST (SC-009 → SC-016)
_Phase WDS-5_
_Source UX : `design-artifacts/D-UX-Design/batch-02-ingest.md`_

---

## SC-009 — Lancer un ingest depuis le dashboard

| Élément | Copy |
|----------|------|
| Titre section | `Nouvel ingest` |
| CTA | `Ajouter une source` |
| Badge empty | `Aucun ingest récent. Lancez le premier.` |

---

## SC-010 — Choisir le mode d’ingestion

| Élément | Copy |
|----------|------|
| Titre | `Choisir une source` |
| Description | `Sélectionnez le type de contenu à ingérer.` |
| CSV | `Fichier CSV` |
| PDF | `Document PDF` |
| YouTube | `Vidéo YouTube` |
| Notion | `Base Notion` |
| Obsidian | `Vault Obsidian` |
| Audio | `Fichier audio` |

---

## SC-011 — Importer depuis un fichier local

| Élément | Copy |
|----------|------|
| Titre | `Importer un fichier` |
| Description | `Glissez vos fichiers ici ou parcourez votre disque.` |
| CTA secondaire | `Parcourir` |
| Formats acceptés | `CSV, PDF, TXT, EPUB, ZIP` |
| Limite | `2 Go maximum par fichier` |
| Erreur format | `Format non supporté` |
| Erreur taille | `Fichier trop volumineux` |

---

## SC-012 — Configurer les paramètres d’extraction

| Élément | Copy |
|----------|------|
| Titre | `Paramètres d’extraction` |
| Label langue | `Langue principale` |
| Label OCR | `Activer l’OCR` |
| Label transcription | `Activer la transcription audio` |
| Label chunking | `Mode de découpe` |
| CTA secondaire | `Annuler` |
| CTA primaire | `Lancer l’ingest` |

---

## SC-013 — Suivre la progression en temps réel

| Élément | Copy |
|----------|------|
| Titre | `Ingestion en cours` |
| Étape | `Étape {n}/{total}` |
| Label durée | `~ {n} min restantes` |
| Badge running | `En cours` |
| Badge completed | `Terminé` |
| Badge failed | `Échec` |
| CTA pause | `Pause` |
| CTA reprise | `Reprendre` |
| CTA annuler | `Annuler` |

---

## SC-014 — Annuler / reprendre un ingest

| Élément | Copy |
|----------|------|
| Titre confirmation | `Interrompre l’ingest ?` |
| Description | `La progression actuelle sera conservée.` |
| CTA confirmer | `Interrompre` |
| CTA annuler | `Continuer l’ingest` |
| Toast reprise | `Ingest repris` |
| Toast annulation | `Ingest interrompu` |

---

## SC-015 — Recevoir une notification d’ingest terminé

| Élément | Copy |
|----------|------|
| Titre toast | `Ingest terminé` |
| Description | `3 402 chunks prêts à être utilisés.` |
| CTA toast | `Ouvrir le résultat` |
| Badge sidebar | `Nouvel ingest` |

---

## SC-016 — Gérer les erreurs (fichier corrompu / quota)

| Élément | Copy |
|----------|------|
| Titre erreur | `Ingest interrompu` |
| Description | `Impossible de traiter archive.zip : archive protégée par mot de passe.` |
| CTA télécharger log | `Télécharger le log` |
| CTA réessayer | `Réessayer` |
| CTA ignorer | `Ignorer` |
| Quota dépassé | `Quota dépassé : 2 Go maximum par fichier.` |

---

## Traçabilité WDS-5

| Fichier | Phase | Rôle |
|---------|-------|------|
| `.../D-UX-Design/batch-02-ingest.md` | WDS-4 | UX source SC-009→SC-016 |
| `.../E-Copywriting/batch-02-ingest.md` | WDS-5 | Copy associé |
