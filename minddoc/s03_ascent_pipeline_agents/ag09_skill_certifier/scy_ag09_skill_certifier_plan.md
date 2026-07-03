<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
ASCENT en MVP avec Plan C refactor (domain contract consumption). AGENT-08/10/11/15/16/17/18 différés.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-AG09-SKILL-CERTIFIER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG09_SKILL_CERTIFIER_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

---

## 🏖️ BEACHHEAD SCOPE — Cyber SOC/Blue-Team MVP

> **Référence** : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md`

| Attribut | Valeur |
|----------|--------|
| **Scope** | IN_MVP |
| **Phase MVP** | Jours 1-28 |
| **Phase expansion** | Post-MVP (PIVOT_ARCHITECTURE §17) |

### Ce qui change pour le cyber beachhead

• Adapté pour contexte cyber beachhead (SOC/blue-team)
• Personas rebrandés pour opérateurs cyber
• Conserve la mécanique core, change l'instanciation métier

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Flux de Données de l'Agent

```
 [Objectif terminé (tous nœuds DAG complétés)]
                 │
                 ▼
   [Step Mastra : skillCertifierStep]
                 │
   [Évaluation théorique : SMI global ≥ seuil (AG05) + examen SurveyJS]
                 │
        ┌────────┴────────┐
        ▼                 ▼
  [Théorie validée]  [Échec → pas de certif]
        │
        ▼
  [Évaluation pratique : simulation ARENA (AGENT-11)]
                 │
        ┌────────┴────────┐
        ▼                 ▼
  [Pratique validée] [Échec → pas de certif]
        │
        ▼
  [Génération Proof of Skill (SMI global + dimensions)]
                 │
                 ▼
  [Signature hash vérifiable + persistance mfg_certificates]
                 │
                 ▼
  [Export PDF / partage + EventBus GoalCompleted]
```

---

## 2. Dépendances Techniques Strictes
* **Théorie** : SMI global (AGENT-05), SurveyJS (`s05`).
* **Pratique** : ARENA (AGENT-11).
* **Validation cognitive** : AGENT-13 (contenus d'examen).
* **Signature** : hash signé (intégrité/authenticité).
* **Zod** : `CertificateSchema`.
* **Tables** : `mfg_certificates`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag09_skill_certifier.ts`** : Step Mastra (certification).
- **`backend_ts/src/ascent/cert/certificate_generator.ts`** : Génération + signature Proof of Skill.
- **`backend_ts/src/ascent/schemas/certificate_schema.ts`** : Schéma Zod du certificat.
- **`mfg_certificates`** : Persistance (user_id, goal_id, smi_global, dimensions, hash, issued_at).
