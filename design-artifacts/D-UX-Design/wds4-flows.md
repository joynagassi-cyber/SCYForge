# SCY Forge — WDS-4 Flows d’interaction (Step 03)
_Périmètre : 87 scénarios_
_Source : `design-artifacts/D-UX-Design/batch-*-*.md`_

---

## Règles transversales

- Toute transition d’écran se fait en 2 clics maximum depuis le point d’entrée indiqué.
- Les états `idle / loading / error` sont systématiques et cohérents.
- Les feeds d’événements (logs, progression, notifications) sont time-order décroissants.

---

## Flux 01 — Onboarding vers première session

```
Landing → Login (SC-001) → Onboarding (SC-003) →
Dashboard (SC-005) → CTA INGEST (SC-009) →
Source choisie (SC-010) → Lancement (SC-011) →
Progression (SC-013) → Notification (SC-015)
```

### Points d’attention
- Onboarding skippable, mais profil minimal conservé
- Si une ingest est déjà en cours au login, proposer reprise immédiate

---

## Flux 02 — Génération learning object (NEURON → APEX)

```
Dashboard → NEURON objectif (SC-017) →
Mode sélectionné (SC-018) → Génération (SC-019) →
Validation (SC-020) → Création deck APEX (SC-021) →
Session révision (SC-022)
```

### Points d’attention
- « Generating » isolé ; navigation libre conservée
- Retour éditable obligatoire avant conversion APEX

---

## Flux 03 — Visualisation cognitive (COSMOS ↔ BRAIN)

```
Dashboard → COSMOS (SC-023) →
Lentille (SC-024) →
Exploration / filtre / annotation (SC-025 à SC-029) →
Basculer mode (SC-030) →
Ouvrir BRAIN (SC-031) →
Question liée (SC-032)
```

### Points d’attention
- BRAIN en modale overlay
- Réponse BRAIN peut pointer vers un node COSMOS (navigation croisée)

---

## Flux 04 — Supervision pipeline (ASCENT)

```
Dashboard → ASCENT (SC-043) →
Configurer pipeline (SC-044) →
Exécution (SC-045) →
Logs (SC-046) →
Échec si nécessaire (SC-047) →
Planification / notifs (SC-048 / SC-049)
```

### Points d’attention
- Pause/arrêt accessibles en 1 clic
- Logs filtrables avant export

---

## Flux 05 — B2B Finance

```
B2B Console → Espace équipe (SC-063) →
Membres (SC-064) →
Rôles (SC-065) →
Finance synthèse (SC-068) →
Rapprochement (SC-069) →
Export reporting (SC-070)
```

### Points d’attention
- Séparation stricte des périmètres B2B et Finance Suite
- Export toujours proposé en fin de flux métier

---

## États globaux partagés

| État | Couple écran concerné | Règle |
|------|----------------------|-------|
| Loading | Tous | Progress ou spinner, < 2s attendu |
| Empty | INGEST, ASCENT, ARENA, Finance | State #1 : tutoriel contextuel ; state #2 : CXC usuel |
| Error | INGEST, ASCENT, B2B | Message court, action primaire, log secondaire |
| Offline | Tous | Bandeau discret, cache lu, retry explicite |

---

## Traçabilité WDS-4

| Fichier | Phase | Rôle |
|---------|-------|------|
| `design-artifacts/D-UX-Design/batch-*-*.md` | WDS-4 | Spécifications UX par scénario |
| `design-artifacts/D-UX-Design/wds4-flows.md` | WDS-4 | Flows et séquences d’interaction |
| `design-artifacts/D-Design-System/tokens.css` | WDS-7 | Tokens autorisés |
