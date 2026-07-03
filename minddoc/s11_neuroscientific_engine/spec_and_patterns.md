<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# Module 11 : Le Moteur Neuroscientifique (ENGRAM, RIF) — ENVIRONNEMENT TECHNIQUE DE CODAGE DE RÉFÉRENCE
**ID Module** : S11_NEUROSCIENTIFIC_ENGINE  
**Statut de Sûreté** : 🟢 INTÉGRITÉ COGNITIVE ET TECHNIQUE VALIDÉE (ZÉRO INVENTIONS AUTORISÉES)  
**Date d'Émission** : 2026-06-12  

---

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

## 🧭 Fiche de Synthèse
* **Description Fonctionnelle** : Calculs de vitalité, dormance froide et compétition synaptique.
* **Stack Technique Officielle** : Rust (Axum), sqlx, Northflank PostgreSQL, LanceDB
* **Patterns d'Ingénierie à Respecter** : Équation d'ENGRAM Sigmoïdale, synapic_competition, Fail-Safe Gate

---

# 🧠 MODULE 11 : Le Moteur Neuroscientifique (ENGRAM, RIF) — Spécifications de Codage

## 1. Description du Module
Gère le cycle de vie de la vitalité, l'hibernation froide (`scy_engram_vault`) et la résurrection active de la connaissance d'un utilisateur.


---

## 🛑 DIRECTIVES STRICTES CONTRE L'HALLUCINATION (AI DE CODELING)
Pour garantir la réussite absolue du codage de ce module par nos agents de développement :
1. **Ne jamais inventer d'APIs tierces** : Utilise scrupuleusement les bibliothèques et connecteurs listés dans la stack.
2. **Ne pas modifier les structures de données** : Référence-toi à l'index SQL consolidé de la base de données Northflank.
3. **Respecter la palette de couleurs spatiale** : Ne jamais introduire de rouge ou de bleu fade en dehors des tokens d'interface fixés dans `design.md`.
4. **Validation des schémas** : Tout retour JSON d'agent s'appuie sur la validation stricte de modèles **Zod** avec gestion de retries.
