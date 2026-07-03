<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag17_work_mode_detector DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🤖 SCY-AG17-WORK-MODE-DETECTOR — SPÉCIFICATION (SPEC)
**ID** : S03_AG17_WORK_MODE_SPEC · **Phase** : V1 · **Réf** : PRD §7.5.17

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
L'**AI-Era Work Mode Detector** détecte le mode de travail réel de l'utilisateur (Traditional / AI-Assisted / AI-Native) et **adapte les critères de validation ASCENT** en conséquence. En 2026, valider un dev sur « écrire un tri à la main » n'a plus de sens.

## 2. Les 3 Modes

| Mode | Profil | Critères ASCENT |
|------|--------|-----------------|
| **A — Traditional** | IA peu utilisée | Mémorisation 40%, compréhension 30%, application 20%, raisonnement 10%. Seuil 70. |
| **B — AI-Assisted** | IA modérée | Compréhension 30%, application 25%, raisonnement 15%, validation output IA 10%. Seuil 72. |
| **C — AI-Native** | IA intensive (devs, DS) | Raisonnement 30%, prompt engineering, validation critique IA, architecture décision, edge cases, méta-compétence. Seuil 75. |

## 3. Détection
- Questions onboarding (3 adaptatives) + détection comportementale passive (temps exercices, questions BRAIN, patterns Teach-Back)
- Table `scy_user_work_mode`

## 4. Exercices adaptés (Mode C)
- Non plus « implémente un tri » mais « l'IA propose timsort avec justification partiellement incorrecte → identifie l'erreur, justifie le choix, réécris le prompt »

## 5. Tests
- TC1 : Mode détecté (A/B/C). | TC2 : Critères ASCENT pondérés selon mode. | TC3 : Exercice Mode C (validation critique IA).
