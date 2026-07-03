<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag10_chronicle DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🤝 SCY-AG10-CHRONICLE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S03_ASCENT_AG10_CHRONICLE_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

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

## 0. Référence croisée
Cette spec couvre la **mission d'orchestration et le rôle « co-pilote de vie quotidienne »** de CHRONICLE. L'**architecture cognitive profonde** (mémoire hiérarchique HMO/APEX, A-MEM, Differential Privacy, Spiritual.AI) est détaillée dans le document dédié **`scy_chronicle_agent_brain_spec.md`**, auquel la présente spec renvoie.

---

## 1. Purpose
Cette spécification définit le comportement de l'**AGENT-10 : CHRONICLE**, l'agent compagnon omniprésent de SCY Forge. Sa mission est d'être le **coéquipier quotidien en vie réelle** : gérer les imprévus, reprogrammer les sessions d'apprentissage, maintenir la continuité motivationnelle et assurer une **présence multi-plateforme cohérente** (WhatsApp, Telegram, Discord, app). Il transforme la pipeline d'un outil en un partenaire permanent.

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Step continu + passerelle de messagerie).
* **Passerelle multi-canal** : connecteurs WhatsApp / Telegram / Discord / app native.
* **Cerveau cognitif** : architecture mémoire hiérarchique (HMO/APEX), A-MEM, Differential Privacy — cf. `scy_chronicle_agent_brain_spec.md`.
* **Dépendances internes** : AGENT-07 (signaux drift → interventions), AGENT-08 (motivation), ASCENT (reprogrammation de sessions).
* **Validation** : modèles **Zod** pour les messages et reprogrammations.
* **EventBus** : `UserOnboarded`, reprogrammations de sessions.

> **Rappel anti-hallucination** : CHRONICLE s'appuie sur les souvenirs consolidés (Niveau 1-3) pour les réponses long-terme, jamais sur la mémoire brute Niveau 0 non consolidée. Confidentialité : chiffrement on-device + Differential Privacy avant sync cloud (cf. brain spec).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Co-pilote de Vie Quotidienne

#### Scénario : Gestion des imprévus et reprogrammation
- **GIVEN** Un utilisateur signalant un imprévu (ex : « Je ne peux pas réviser ce soir ») sur un canal.
- **WHEN** CHRONICLE traite le message.
- **THEN** le système SHALL reprogrammer la session d'apprentissage ASCENT de manière souple.
- **AND** le système SHALL préserver la continuité du streak (AGENT-08) si possible.
- **AND** le système SHALL proposer une alternative réaliste (micro-session, report).

---

### Requirement : Présence Multi-Plateforme Cohérente

#### Scénario : Continuité d'identité sur les canaux
- **GIVEN** Un utilisateur interagissant sur plusieurs plateformes (WhatsApp, Discord, app).
- **WHEN** CHRONICLE répond.
- **THEN** le système SHALL maintenir une **identité ontologique sémantique unique** sur tous les canaux.
- **AND** le système SHALL synchroniser le contexte via la mémoire consolidée (Niveau 1-3).
- **AND** le système SHALL appliquer le chiffrement on-device + Differential Privacy pour toute sync cloud.

---

### Requirement : Soutien Motivationnel Proactif

#### Scénario : Intervention sur signal de drift
- **GIVEN** Un signal de drift de l'AGENT-07 (stress, décrochage, inactivité).
- **WHEN** CHRONICLE intervient.
- **THEN** le système SHALL proposer un soutien ciblé (rappel motivant, micro-objectif AGENT-08, suggestion Hagah/méditation si stress élevé).
- **AND** le système SHALL s'appuyer sur les souvenirs sémantiques (Niveau 3) pour personnaliser le soutien.

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Répondre à une requête long-terme avec la mémoire brute Niveau 0 non consolidée (cf. brain spec).
* 🚫 **FORBIDDEN** : Transmettre des données sensibles en clair sur le cloud (chiffrement + DP obligatoires).
* 🚫 **SHALL NOT** : Rompre la cohérence d'identité entre canaux.
* 🚫 **MUST NOT** : Modifier la palette de couleurs hors des tokens de `design.md`.
* ⚠️ **MUST** : Messages et reprogrammations validés par **Zod**.

---

## 5. Test cases & Validation
* **Test Case 1 (Imprévu)** : Un signal d'imprévu déclenche une reprogrammation souple préservant le streak si possible.
* **Test Case 2 (Multi-canal)** : L'identité reste cohérente sur WhatsApp/Discord/app.
* **Test Case 3 (Confidentialité)** : Aucune donnée sensible en clair dans la sync cloud (DP appliquée).
* **Test Case 4 (Drift)** : Un signal de stress déclenche un soutien ciblé personnalisé.
* **Test Case 5 (Mémoire)** : Une requête long-terme utilise la mémoire consolidée Niveau 1-3, pas la brute Niveau 0.
