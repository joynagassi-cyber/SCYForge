# 🛠️ SCY-AG09-SKILL-CERTIFIER — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG09_SKILL_CERTIFIER_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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
