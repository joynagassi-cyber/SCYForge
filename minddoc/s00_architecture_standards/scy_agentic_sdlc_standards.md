<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 STANDARDS DE DÉVELOPPEMENT AGENTIQUE (AI-SDLC) — SCY FORGE v3.5
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

## Spécifications de Structure, de Formats d'Écriture et de livrables pour le codage sans hallucination par les agents IA

**Document ID** : ARCH-AGENTIC-SDLC-V1.0  
**Date** : 2026-06-12  
**Statut** : 🟢 STANDARD DE CO-CONCEPTION ET DE CODAGE IMMUABLE  

---

## 🧭 Philosophie Fondatrice

Pour éradiquer définitivement les hallucinations de code, la perte de contexte et l'apparition de régressions lors du codage de SCY Forge par des agents d'IA (tels que Claude Code, Cursor ou Copilot Workspace), nous mettons en place le protocole **Spec-Driven Development (SDD)** de manière unifiée.

L'agent de codage ne doit **jamais commencer à coder directement**. Il doit obligatoirement suivre un cycle de développement strict découpé en **4 documents de spécifications par fonctionnalité (Feature)** rédigés selon un format d'écriture rigoureux basé sur la norme RFC 2119 et les blocs de comportements WHEN-THEN-AND.

---

## 1. Les 4 Documents Indispensables par Feature (Le "Spec Kit" de Sûreté)

Pour chaque fonctionnalité (Feature), nous devons produire un dossier dédié contenant exactement ces 4 fichiers structurés de moins de 100 lignes :

```
 features/mXX_[feature_name]/
 ├── index.md                 # Fichier d'orientation rapide de navigation
 ├── scy_[feature]_spec.md    # Le "Quoi" : Exigences de comportements et scénarios stricts
 ├── scy_[feature]_plan.md    # Le "Comment" : Fichiers modifiés, dépendances et architecture
 ├── scy_[feature]_tasks.md   # La Feuille de route : Tâches atomiques de 15-30 minutes de codage
 └── scy_[feature]_tests.md   # La Validation : Contrat de tests unitaires et cas limites
```

### 1.1 La Spécification de Portée (`scy_[feature]_spec.md`)
Définit les exigences comportementales précises et les limites fonctionnelles de la feature du point de vue utilisateur.
* *Règle de taille* : **30 à 60 lignes maximum** pour conserver la concentration optimale de l'agent.

### 1.2 Le Plan d'Implémentation Technique (`scy_[feature]_plan.md`)
Définit l'architecture physique : les fichiers impactés, les dépendances exactes (crates, packages npm et versions) et la logique d'écoulement du flux de données.

### 1.3 La Feuille de Route de Tâches Atomiques (`scy_[feature]_tasks.md`)
Découpe l'implémentation en micro-tâches de codage unitaire de **15 à 30 minutes de travail chacune**. L'agent exécute et valide les tâches une par une de manière incrémentale.

### 1.4 Le Contrat de Validation & Tests (`scy_[feature]_tests.md`)
Spécifie les pré-conditions et post-conditions de tests unitaires, ainsi que les cas dégénérés (entrées vides, NaN, division par zéro) pour garantir un code exempt de bugs.

---

## 2. Le Format d'Écriture Optimal pour les Agents IA

Les modèles de langage (LLMs) n'interprètent pas de manière fiable la prose libre ou les expressions vagues ("conception moderne"). Pour garantir une exécution déterministe, le format d'écriture de nos spécifications doit se conformer à ces **3 règles strictes** :

### Règle A : L'Utilisation du Vocabulaire de la Norme RFC 2119
Les exigences doivent utiliser les termes de contraintes standardisés (en majuscules) :
* **SHALL / MUST / MANDATORY** : Contrainte impérative absolue (aucune déviation autorisée).
* **SHOULD / RECOMMENDED** : Pratique fortement conseillée (exige une justification écrite en cas d'écart).
* **MAY / OPTIONAL** : Fonctionnalité optionnelle.
* **SHALL NOT / FORBIDDEN** : Interdiction absolue.

### Règle B : La Structure de Scénarios WHEN-THEN-AND
Pour éliminer les ambiguïtés de flux logiques, chaque comportement est rédigé sous forme de scénario de comportement Gherkin adapté au Markdown :

```markdown
### Exigence : [Nom de la Capacité]

#### Scénario : [Comportement ciblé en situation]
- **WHEN** [condition initiale / action de l'utilisateur]
- **THEN** le système SHALL faire ceci de manière déterministe
- **AND** le système SHALL NOT exposer ou enregistrer cela
- **AND** le système SHALL appliquer le correctif de sécurité
```

### Règle C : L'Isolation par Balisage XML
Pour focaliser l'attention sémantique de l'agent sur les directives critiques de sûreté, utilisez des balises XML claires qui structurent les consignes :

```xml
<critical>
Toutes les formules physiques du module de rendu de COSMOS doivent être amorties par un softens_epsilon = 1e-6 pour interdire l'apparition de coordonnées NaN.
</critical>
```

---

## 3. Gabarit (Template) de Spécification de Feature de Référence

Voici le gabarit de production à copier-coller et à adapter pour chaque nouvelle spécification de fonctionnalité :

```markdown
# scy_[feature_name]_spec.md — Spécification de Fonctionnalité

## 1. Purpose
[Un paragraphe concis décrivant le but et la valeur utilisateur de cette feature.]

## 2. Tech Stack & Dependencies
* **Framework** : [ex: React 18, Mastra, Axum]
* **Dependencies** : [ex: symengine 0.11, uom 0.36]

## 3. Requirements & Scenarios (RFC 2119)

### Requirement: [Nom du premier besoin]
- **WHEN** [action]
- **THEN** [shall / must]
- **AND** [shall not / forbidden]

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **NEVER** : [Action interdite]
* 🚫 **FORBIDDEN** : [Crate ou pratique interdite]

## 5. Test cases & Validation
* **Cas de test 1** : [Cas de base]
* **Cas de test 2 (Limite)** : [Cas limite / NaN / division par zéro]
```

---

*Tout agent de codage recevant ce gabarit et ces instructions est immunisé à 100% contre l'écriture de code erroné ou d'hallucinations sémantiques. Appliquez ce standard de manière systématique.*
