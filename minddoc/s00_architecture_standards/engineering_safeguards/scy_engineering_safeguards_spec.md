<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛡️ SCY-ENGINEERING-SAFEGUARDS — SPÉCIFICATION (SPEC)
**ID** : S00_ENGINEERING_SAFEGUARDS_SPEC · **Phase** : P1 · **Réf** : PRD §15.9 (D-OPT-020/025/026/031)

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

## 1. Purpose
Consolidation des **safeguards d'ingénierie** de sécurité et de résilience locale, transverses au moteur Rust/React.

## 2. Les 4 Safeguards

### D-OPT-020 — Local Telemetry Debouncing
- Accumuler et regrouper (debouncer) sur **5 secondes** les mises à jour de vitalité synaptique `V_n(t)` sur le client avant transmission par lots asynchrones à Northflank.
- Réduit la charge réseau et serveur (batch vs requêtes individuelles).

### D-OPT-025 — Adversarial RAG Context Guardrail
- Filtrer déterministiquement et assainir **tous les chunks RAG** (Zilliz) pour **strip-détecter les injections de prompts malveillantes** avant injection à l'APEX-AGENT.
- Anti prompt-injection sur les sources externes ingérées.

### D-OPT-026 — Offline-First Local Sync Queue
- Enregistrer toutes les interactions et progressions FSRS locales dans `scy_sync_queue` de l'**IndexedDB** locale du navigateur.
- Un **service worker** pousse asynchronement les lots à Northflank dès le retour du réseau.
- 100% offline capable.

### D-OPT-031 — Persistent IndexedDB WAL
- Sauvegarder la file `scy_sync_queue` locale sous forme de **journal de transactions persistantes (Write-Ahead Log)** dans IndexedDB.
- Assure la **résilience et l'auto-réparation** en cas de crash brutal du navigateur.

## 3. Requirements (RFC 2119)
- **D-OPT-020** : Le système SHALL debouncer la télémétrie sur 5s avant transmission batch.
- **D-OPT-025** : Le système SHALL strip-détecter les injections de prompts dans tous les chunks RAG.
- **D-OPT-026** : Le système SHALL stocker les interactions FSRS en IndexedDB + service worker sync.
- **D-OPT-031** : Le système SHALL persister le sync queue en WAL IndexedDB (résilience crash).

## 4. Tests
- TC1 : Télémétrie debouncée 5s (batch). | TC2 : Chunk RAG avec injection → strippé. | TC3 : Offline → IndexedDB + service worker sync au retour réseau. | TC4 : Crash navigateur → WAL IndexedDB auto-réparation.
