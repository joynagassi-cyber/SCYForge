<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📥 SCY-WEB-ARTICLE-CORE — SPÉCIFICATION DE COMPORTEMENT (SPEC)
**ID Spécification** : S01_INGESTION_WEB_SPEC  
**Statut** : 🟢 SPÉCIFICATION DE PORTÉE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin WHEN-THEN-AND) + Norme RFC 2119  

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

## 1. Purpose
Cette spécification définit le comportement sémantique et fonctionnel du **Core d'Ingestion Web & Article (`c02_web_article_core`)** de SCY Forge. Le système doit être capable d'extraire, de nettoyer (suppression de publicités, bandeaux de cookies et paywalls) et de structurer sous forme de Markdown épuré tout contenu d'article ou de page web technique à partir d'une simple URL, à coût d'infrastructure nul (0$).

---

## 2. Tech Stack & Dependencies
* **Framework** : Mastra TypeScript (Orchestration) + Rust Axum (Moteur de calcul)
* **Dependencies** : **Scrapling** (Service d'extraction furtif Docker), `dom_smoothie` (Readability library), `jsdom`, Joup / Floki (Rust html parsers).

---

## 3. Requirements & Scenarios (RFC 2119)

### Requirement: Extraction Furtive & Contournement Anti-Bot

#### Scénario : Capture et contournement de Cloudflare via Scrapling
- **GIVEN** Un lien URL d'article web technique protégé par des pare-feux anti-bots (ex : Medium, substack).
- **WHEN** L'agent `CONTENT-SCOUT (AGENT-02)` lance le processus d'ingestion.
- **THEN** le système SHALL déléguer la requête de capture au microservice **Scrapling** s'exécutant localement sous Docker.
- **AND** Scrapling MUST utiliser son moteur d'empreinte navigateur furtif (`CloakBrowser`) pour contourner les protections Cloudflare ou les Captchas sans intervention humaine.
- **AND** le système SHALL récupérer le document HTML brut en moins de 3 secondes.

---

### Requirement: Nettoyage et Extraction Sémantique (DOM Smoothie)

#### Scénario : Purge des éléments parasites et conversion Markdown
- **GIVEN** Un document HTML brut capturé par Scrapling contenant des publicités, des scripts de tracking et des bandeaux d'acceptation de cookies.
- **WHEN** Le système passe le document au filtre de nettoyage.
- **THEN** le système SHALL invoquer **`dom_smoothie`** (Readability) pour purger : les balises `script`, `style`, `iframe`, les menus latéraux (`aside`, `nav`), et les popups de publicités.
- **AND** le système SHALL extraire le corps principal du texte, le titre de l'article, les métadonnées OpenGraph (description, thumbnail), et les noms d'auteurs.
- **AND** le système SHALL convertir le HTML nettoyé en Markdown standard (GFM CommonMark 0.31).
- **AND** le système SHALL enregistrer le résultat dans `mfg_project_sources`.

---

### Requirement: Résilience de Secours (Offline Cache & Paywall detection)

#### Scénario : Alerte de blocage de Paywall
- **GIVEN** Une page web masquée par un paywall d'inscription obligatoire.
- **WHEN** Scrapling détecte la présence de verrous de type paywall (corps de texte vide ou haché).
- **THEN** le système SHALL NOT faire planter la boucle d'apprentissage.
- **AND** le système SHALL tenter d'extraire la version de cache archivée publique (via Wayback Machine ou l'index de recherche).
- **AND** en cas d'échec de secours, le système MUST lever une exception socratique propre : *"Cette source est verrouillée par un paywall. Merci de soumettre le document brut au format PDF ou EPUB dans votre espace."*

---

## 4. Boundaries & Constraints (Ce qu'il ne faut PAS faire)
* 🚫 **FORBIDDEN** : Faire des requêtes d'écritures ou de scraping synchrones de plus de 15 secondes sur le thread principal de l'UI (toujours déléguer à la file asynchrone).
* 🚫 **MANDATORY** : Purger systématiquement tout script Javascript (`<script>`) ou balise dynamique malveillante du document extrait avant de le stocker pour éviter les failles d'injection de scripts XSS sur le client React.

---

## 5. Test cases & Validation
* **Test Case 1 (Anti-Bot)** : Valider que la soumission d'une URL de blog Medium protégée renvoie un article de texte épuré d'une netteté de 100%.
* **Test Case 2 (Filtre publicitaire)** : Vérifier que le volume de texte publicitaire (bannières, boutons "partager") est éliminé de la table de sortie, mesuré par un taux d'épuration sémantique de plus de 95%.
