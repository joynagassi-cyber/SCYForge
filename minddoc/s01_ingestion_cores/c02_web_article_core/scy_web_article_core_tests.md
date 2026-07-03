<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Ingestion générique (13 cores) DEFERRÉE. Beachhead = Domain Pack pré-chargé.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-WEB-ARTICLE-CORE — CONTRAT DE VALIDATION & TESTS (TESTS)
**ID Spécification** : S01_INGESTION_WEB_TESTS  
**Statut** : 🟢 SUITE DE TESTS DE SÛRETÉ PRÊTE POUR INTÉGRATION  

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

## 1. Scénarios de Validation Unitaires

### 🧪 Test 1.1 : Validation d'extraction Furtive Scrapling
* **Pré-conditions** : Le microservice Docker Scrapling est actif et connecté.
* **Input** : Un lien de blog Medium complexe sous Cloudflare protection.
* **Règle d'Exécution** : Lancer `scraplingClient.fetchHTML()`.
* **Post-conditions (Attendu)** :
  - Le document retourné contient l'intégralité du code HTML sémantique.
  - La requête ne renvoie aucun code d'erreur de blocage Cloudflare (403/503).

### 🧪 Test 1.2 : Élimination Radicale de Publicités et Anti-XSS
* **Pré-conditions** : HTML d'entrée pollué par des scripts publicitaires malveillants de type `<script>alert('XSS')</script>`.
* **Input** : Contenu HTML brut infecté.
* **Règle d'Exécution** : Exécuter la fonction `webMetadataSanitizer.sanitize()`.
* **Post-conditions (Attendu)** :
  - Le Markdown de sortie ne contient aucun tag de type script ou élément de programmation dynamique.
  - Tout code de pub ou menu latéral a été éliminé avec succès (taux de propreté sémantique > 95%).

### 🧪 Test 1.3 : Gestion Socratique du Blocage de Paywall
* **Pré-conditions** : Ingestion d'une page masquée par un paywall d'inscription strict.
* **Input** : Un lien d'article payant inaccessible.
* **Règle d'Exécution** : Lancer l'ingestion principale de `webArticleCore.ts`.
* **Post-conditions (Attendu)** :
  - Le système détecte l'absence de texte (paywall).
  - L'agent n'insère aucune donnée corrompue en base de données.
  - Le système génère une alerte socratique propre invitant l'élève à téléverser le document brut lui-même.
