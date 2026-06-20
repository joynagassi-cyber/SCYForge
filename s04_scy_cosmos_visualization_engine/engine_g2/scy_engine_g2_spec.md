# 📊 SCY-ENGINE-G2 — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S04_COSMOS_ENGINE_G2_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

---

## 0. Frontière avec engine_statistical (Complémentarité)
* **engine_g2** (ce document) est la **couche primitive de graphiques généraux** (AntV G2, grammaire graphique) : barres, lignes, aires, camemberts pour les indicateurs UI génériques.
* **engine_statistical** est la **couche supérieure spécialisée** : visualisations statistiques/scientifiques spécifiques à l'apprentissage (heatmaps, matrices de corrélation, Sankey, distributions SMI). Les deux sont complémentaires.

---

## 1. Purpose
Cette spécification définit le comportement du **moteur engine_g2**, basé sur **AntV G2 (v5)**. Il fournit les **graphiques génériques de la grammaire graphique** (barres, lignes, aires, camemberts, jauges) utilisés dans les tableaux de bord et indicateurs de progression de SCY Forge (XP, streaks, SMI global dans le temps, etc.).

---

## 2. Tech Stack & Dependencies
* **Framework** : React 18 + **AntV G2 v5** (`@antv/g2`, grammaire graphique).
* **Rendu** : Canvas/WebGL haute performance.
* **Design** : tokens `design.md`.
* **Intégration** : données d'indicateurs (AGENT-05 SMI, AGENT-08 XP/streaks), EventBus.

> **Rappel anti-hallucination** : AntV G2 v5 est la librairie réelle de la grammaire graphique AntV. Palette stricte `design.md`.

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement : Rendu des Graphiques Génériques

#### Scénario : Affichage des indicateurs de progression
- **GIVEN** Des données d'indicateurs (XP, streak, SMI global par semaine).
- **WHEN** engine_g2 rend les graphiques.
- **THEN** le système SHALL afficher les graphiques via AntV G2 v5 (barres/lignes/jauges).
- **AND** le système SHALL respecter les tokens `design.md`.
- **AND** le système SHALL mettre à jour les graphiques en temps réel sur changement de données.

---

### Requirement : Réactivité & Performance

#### Scénario : Mises à jour en direct
- **GIVEN** Un tableau de bord affichant des indicateurs.
- **WHEN** Les données sous-jacentes changent (EventBus).
- **THEN** le système SHALL rafraîchir les graphiques sans rechargement complet.
- **AND** le système SHALL maintenir une animation fluide.

---

## 4. Boundaries & Constraints
* 🚫 **FORBIDDEN** : Couleurs hors des tokens `design.md`.
* 🚫 **SHALL NOT** : Implémenter ici les visualisations statistiques spécialisées (rôle d'engine_statistical).
* ⚠️ **MUST** : Validation Zod des données d'indicateurs.

---

## 5. Test cases & Validation
* **Test Case 1 (Graphiques)** : XP/streak/SMI s'affichent via G2 v5 avec la palette officielle.
* **Test Case 2 (Temps réel)** : Les graphiques se rafraîchissent sur changement de données.
* **Test Case 3 (Palette)** : Aucune couleur hors tokens.
