# WDS-3 — BATCH 08
_Modules : Harmonist QA gates + Normal Mode + Neuroscience Engine_
_Couverture : SC-055 à SC-062_
_Priorité : tous personas + couverture PIVOTIQ + Finance Suite_

---

## SC-055 — Harmonist — QA gate inbound content

**Persona** : P-AL, P-KG
**Business goal** : Qualité certifiée avant publication
**Trigger** : Fin de génération NEURON-CHAINS / ingestion
**Écran** : `/harmonist/queue`
**Flux** :
1. `HarmonistQBAPanel` collette les items en attente QA.
2. Gate checklist : anti-hallucination, citation check, harmoniste cognitif.
3. Actions : [Approuver], [Demander correction], [Rejeter].
4. HITL : `AscensionAg16HITL` proposé quand score ambigu.
5. Historique : 7j + export PDF.
**Spec** : `minddoc/s09_harmonist_validation_gates/`
**Tokens** : `scy-color-feedback-*`, badge statut, stepper 3-étapes.

---

## SC-056 — Harmonist — Neuro-consolidation

**Persona** : P-AL
**Business goal** : Consolidation neuro-scientifique des cartes
**Trigger** : `NeuroConsolidationService` post-revision APEX
**Écran** : `/neuro/consolidation`
**Flux** :
1. Carte soumise au pipeline neuro-consolidation.
2. Vue reviewer : delta avant/après, métriques neuroscientifiques.
3. Action : [Accepter consolidation], [Rollback].
4. Notifications : ASCENT + Chronicle.
**Spec** : `minddoc/s09_harmonist_validation_gates/`, `s11_neuroscientific_engine/`
**Tokens** : `scy-color-feedback-warning`, card scientifique.

---

## SC-057 — Normal Mode — Ingest rapide non-ascensionnel

**Persona** : P-AL
**Business goal** : Accès rapide à contenu personnel sans pipeline ASCENT
**Trigger** : CTA rapide "Ingest simple"
**Écran** : `/normal/ingest`
**Flux** :
1. Formulaire minimal : URL, type, tags.
2. Traitement court : extraction → stockage → bibliothèque.
3. Option : [Ajouter un objectif ASCENT].
4. Historique : 30 derniers items.
**Spec** : `minddoc/s10_normal_mode_ingestion/`
**Tokens** : stepper 3 étapes, bouton secondaire sombre.

---

## SC-058 — Normal Mode — Coach adaptatif

**Persona** : P-AL
**Business goal** : Apprentissage non structuré avec guidance légère
**Trigger** : `/normal/coach`
**Flux** :
1. `WorkModeDetector` détecte le mode Normal actif.
2. Suggestions de contenu basées sur l’historique bibliothèque.
3. Objectif implicite généré sans roadmap ASCENT.
4. Quick actions : [Réviser], [Lire], [Voir COSMOS].
**Spec** : `minddoc/s10_normal_mode_ingestion/`, `ag17_work_mode_detector`
**Tokens** : suggestion chips, métriques discrètes.

---

## SC-059 — Neuroscience Engine — Suivi cognitif

**Persona** : P-AL
**Business goal** : Mesurer l’engagement et la charge cognitive
**Trigger** : `/neuro/metrics`
**Flux** :
1. Graphe SMI, charge cognitive, focus score.
2. Insights automatiques : pics de concentration, fatigue détectée.
3. Export : CSV + PDF.
4. Lien vers APEX forecast et Harmonist QA.
**Spec** : `minddoc/s11_neuroscientific_engine/`
**Tokens** : `scy-color-feedback-warning`, gauge cognitive.

---

## SC-060 — Neuroscience Engine — Recommandation neuro-adaptative

**Persona** : P-AL
**Business goal** : Adapter le parcours d’apprentissage
**Trigger** : `/neuro/recommendations`
**Flux** :
1. Analyse performance + Neuroscience metrics.
2. Suggestions : meilleur moment, format préféré, charge idéale.
3. Quick action : [Créer objectif ASCENT depuis reco].
4. Historique recommandations.
**Spec** : `minddoc/s11_neuroscientific_engine/`
**Tokens** : chip recommandations, palette intelligence.

---

## SC-061 — PIVOTIQ — Réconciliation financière

**Persona** : P-FA
**Business goal** : Analyser et réconcilier documents financiers
**Trigger** : `/pivotiq/reconcile`
**Flux** :
1. Import 10-K / 10-Q / Earnings / XBRL.
2. Comparaison multi-sources (EDGAR, manuel, Bloomberg).
3. Vue divergences : alignements ✅ / gaps ⚠️ / erreurs 🔴.
4. Actions : [Valider], [Investiguer], [Exporter COSMOS].
**Spec** : specs PIVOTIQ, `docs/ROUTES.md` -> ingestion/financial
**Tokens** : tableau financier, badges divergence, accent amber Finance.

---

## SC-062 — Finance Suite — Génération exécutive output

**Persona** : P-FA, P-B2B
**Business goal** : Produire livrables financiers exploitables
**Trigger** : `/finance-suite/output`
**Flux** :
1. Sélection inputs : PIVOTIQ reconciliation, selections, metadata.
2. Template output : Résumé exécutif | Rapport complet | Deck.
3. Prévisualisation + validation avant publish.
4. Export : PDF/DOCX/PPTX typst-powered.
5. Historique générations.
**Spec** : specs Finance Suite
**Tokens** : template cards, preview pane, palette finance.
