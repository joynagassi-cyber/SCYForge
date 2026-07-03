<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-WEB-ARTICLE-CORE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S01_INGESTION_WEB_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

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

## 1. Architecture du Flux de Données

```
 [URL Web] ──► [Scrapling Docker Service] (Bypass anti-bot)
                      │
                      ▼ [HTML Brut]
               [DOM Smoothie / Readability Engine] (Cleanup)
                      │
                      ▼ [Markdown Epuré]
               [XSS Sanitizer & OpenGraph Extraction]
                      │
                      ▼
         [Écriture scy_project_sources & Zilliz Vectorization]
```

---

## 2. Dépendances Techniques Strictes
* **Service Externe de Scraping** :
  - Microservice **Scrapling** (Python/Chromium headless) hébergé sous forme de conteneur Docker léger à ressources isolées (0$ d'infrastructure, bypass de Cloudflare nativement).
* **Packages Node.js (Mastra)** :
  - `@mozilla/readability` ou `dom_smoothie` (lisseur de DOM).
  - `jsdom` (pour la manipulation de structures d'AST HTML sur le backend).
  - `dompurify` (sécurisateur anti-XSS indispensable avant écriture).

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/normal_pipeline/cores/webArticleCore.ts`** : Contient le code TypeScript d'appel à Scrapling et de nettoyage.
- **`scy_project_sources`** : Stocke le titre, le corps d'article et les tags OpenGraph extraits.
