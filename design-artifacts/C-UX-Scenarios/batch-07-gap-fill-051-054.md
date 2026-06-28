# WDS-3 — BATCH 07 (GAP FILL)
_Couverture : SC-051 à SC-054_
_Pont entre batch 06 (ASCENT) et batch 08 (Harmonist/Normal/Neuro/PivotIQ)_

---

## SC-051 — Harmonist — Citation Integrity Check (P-KG, P-AL)

**Persona** : P-KG, P-AL
**Business goal** : Vérifier que toute affirmation publiée est sourcée
**Trigger** : Soumission contenu avant publication
**Écran** : `/harmonist/citations/:contentId`
**Flux** :
1. CitationTracker scanne chaque marqueur `[n]`
2. Fetch source, vérifie accessibilité, compare extrait vs original
3. Status : ✅ Valid | ⚠️ Partial | 🔴 Broken | ❌ Mismatch
4. Actions bulk et audit log.
**Spec** : `minddoc/s09_harmonist_validation_gates/`
**Tokens** : badge statut, `scy-color-feedback-*`

---

## SC-052 — Harmonist — Reviewer Queue (P-B2B, P-KG)

**Persona** : P-B2B Reviewer, P-KG
**Business goal** : Workflow relecture humain avant publication massive
**Trigger** : Arrivée item dans queue QA
**Écran** : `/harmonist/review/queue`
**Flux** :
1. Queue triée par priorité (deadline, criticité, auteur)
2. Reviewer voit diff + sources + score QA
3. Décision : [Approuver] [Demander correction] [Rejeter]
4. Notification auteur + traçabilité `scy_harmonist_audit`
**Spec** : `minddoc/s09_harmonist_validation_gates/`
**Tokens** : `scy-card`, actions inline, badge priorité

---

## SC-053 — Harmonist — QA Gate Analytics (P-B2B)

**Persona** : P-B2B
**Business goal** : Mesurer la qualité globale du contenu publié
**Trigger** : `/harmonist/analytics`
**Flux** :
1. KPIs : taux approbation, temps moyen review, défauts par type
2. Tendance : évolution qualité sur 30/90 jours
3. Top défauts : hallucinations, citations cassées, formatting
4. Export PDF pour revue management
**Spec** : `minddoc/s09_harmonist_validation_gates/`
**Tokens** : Recharts, `scy-color-success`/`scy-color-alert`

---

## SC-054 — Harmonist — Human-in-the-Loop Escalation (P-AL, P-KG, P-B2B)

**Persona** : P-AL, P-KG, P-B2B
**Business goal** : Faire intervenir un humain quand l’agent bloque
**Trigger** : ASCENT ag16 HITL détecte ambiguïté ou conflit sources
**Écran** : `/ascent/hitl/:requestId`
**Flux** :
1. Notification push avec résumé blocage
2. Panel contextuel : queries agents, résultats contradictoires
3. Choix utilisateur : clarifier, résoudre conflit, valider, rediriger
4. Audit trail + reprise automatique agent après décision
**Spec** : ASCENT `ag16_hitl_proxy_sme`
**Tokens** : `scy-color-alert`, stepper résolution, feedback rapide
