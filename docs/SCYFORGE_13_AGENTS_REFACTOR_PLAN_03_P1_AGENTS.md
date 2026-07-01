# SCYForge — Plan C de refactor des 13 agents ASCENT
## 03. Refactor détaillé des agents P1

## Périmètre P1
Agents qui stabilisent la boucle de progression et la robustesse du système :
- ADAPTIVE-ROUTER
- DRIFT-GUARDIAN
- CHRONICLE
- BRAIN
- APEX / IMPRINT / FSRS

---

# 1. ADAPTIVE-ROUTER

## Cible
Devenir un **Trajectory Policy Engine**.

## Ce qui doit changer
- ne plus router sur score global brut uniquement,
- intégrer criticité, preuve manquante, risque d’oubli, type de faiblesse.

## Décisions attendues
- fast-track borné,
- consolidation ciblée,
- remédiation typée,
- blocage d’avancement,
- ouverture de scénario.

## Dépendances
- `RetentionPolicyProvider`
- `DecisionScenarioProvider`
- `RoleTaxonomyProvider`
- `ValidationGuardProvider`

## Done criteria
- pas de fast-track sans preuve suffisante,
- chaque remédiation cible une faiblesse précise,
- chaque changement de trajectoire est explicable.

---

# 2. DRIFT-GUARDIAN

## Cible
Devenir un **Mastery Erosion Sentinel**.

## Ce qui doit changer
- dépasser la logique de simple inactivité,
- détecter les dérives cognitives et procédurales.

## Signaux attendus
- oubli pur,
- régression de procédure,
- surconfiance,
- faux positifs récurrents,
- effondrement sous ambiguïté,
- stagnation sur compétences critiques.

## Dépendances
- `RetentionPolicyProvider`
- `ProofRubricProvider`
- `ValidationGuardProvider`

## Done criteria
- les signaux de drift sont typés,
- le système peut distinguer abandon, oubli, illusion de maîtrise,
- les interventions sont proportionnées au risque réel.

---

# 3. CHRONICLE

## Cible
Devenir le **Learning Ledger** et la timeline opérable du système.

## Ce qui doit changer
- ne plus être juste un historique narratif,
- devenir une couche consultable par apprenant, système et manager.

## Objets à produire
- `TimelineEvent`
- `AuditTrailEntry`
- `ManagerDigest`
- `ProofMilestone`

## Dépendances
- `CorpusProvider`
- `ProofRubricProvider`
- `ValidationGuardProvider`

## Done criteria
- toute décision critique remonte dans la timeline,
- les preuves importantes sont consultables,
- la narration n’efface jamais la trace brute.

---

# 4. BRAIN

## Cible
Devenir un **Contextual Professor** borné.

## Ce qui doit changer
- cesser d’être un simple assistant RAG,
- devenir une interface d’explication, d’interrogation, de clarification et de signalement de gaps.

## Modes attendus
- grounded answer,
- guided explanation,
- socratic mode,
- teach-back mode,
- gap detection.

## Dépendances
- `CorpusProvider`
- `OntologyProvider`
- `ValidationGuardProvider`

## Done criteria
- toute réponse sensible est sourcée,
- toute sortie indique confiance et provenance,
- le mode tutoriel reste aligné avec les nœuds de maîtrise.

---

# 5. APEX / IMPRINT / FSRS

## Cible
Devenir le **Mastery Preservation Engine**.

## Ce qui doit changer
- ne pas se limiter à des cartes de mémoire factuelle,
- préserver aussi discriminations, procédures et réflexes décisionnels.

## Types de refresh attendus
- concept recall,
- discrimination refresh,
- procedure rehearsal,
- decision rehearsal,
- escalation recall.

## Dépendances
- `RetentionPolicyProvider`
- `ProofRubricProvider`
- `ValidationGuardProvider`

## Done criteria
- chaque activité de rétention est liée à un `MasteryNode`,
- la criticité influence la cadence,
- l’oubli d’une compétence mission-critical déclenche un traitement spécial.

---

# 6. Ordre interne P1 recommandé

1. ADAPTIVE-ROUTER
2. APEX / IMPRINT / FSRS
3. DRIFT-GUARDIAN
4. BRAIN
5. CHRONICLE

### Pourquoi
- ROUTER et rétention doivent être alignés tôt,
- DRIFT a besoin d’une vraie politique de rétention,
- BRAIN doit ensuite se brancher proprement sur les objets stabilisés,
- CHRONICLE vient consolider la traçabilité transverse.

---

# 7. Critère de fin P1

La phase P1 est finie quand :
- la trajectoire est gouvernée par la preuve et la criticité,
- la rétention protège aussi la décision et la procédure,
- le drift détecte de vraies érosions de maîtrise,
- BRAIN reste puissant mais borné,
- CHRONICLE donne une lecture auditée de la progression.
