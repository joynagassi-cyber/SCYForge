# 🛡️ SCY-COSMOS-TRUST-SYSTEM — SPÉCIFICATION (SPEC)
**ID** : S04_COSMOS_TRUST_SYSTEM_SPEC · **Décisions** : D-COSMOS-015, D-COSMOS-016, Double Validation Sceau · **Phase** : P1 🔴

## 1. Purpose
Le **COSMOS Trust System** consolide les 3 mécanismes de confiance visuelle du graphe : le **AI Confidence System** (badge sur toute connexion IA), les **Semantic Edge Styles** (7 types d'arêtes distincts), et le **Sceau de Double Validation** (AI + Humain).

## 2. Les 3 Mécanismes

### A — AI Confidence System (D-COSMOS-015)
- Score multi-signaux : `cosine × 0.45 + source_agreement × 0.30 + maturity × 0.15 + domain × 0.10`
- Styles visuels : HIGH (plein violet) / MEDIUM (tireté) / LOW (pointillé + ⚠️)
- Validation/Rejet : raccourcis V/X + toast undo 10s + persistance `scy_ai_rejections`
- Feedback loop : rejets agrégés (k ≥ 100) → ajustement seuil cosine par domaine

### B — Semantic Edge Styles — 7 Types (D-COSMOS-016)
- Chaque `relation_type` a un style G6 dédié (couleur, dash pattern, flèche, opacité) :
  1. `is_a` (bleu plein) 2. `part_of` (vert plein) 3. `prerequisite_of` (orange tireté)
  4. `example_of` (cyan pointillé) 5. `contradicts` (rouge épais) 6. `related_to` (gris fin)
  7. `cross_domain_analog` (orange spécial)
- Légende auto-générée (uniquement types présents dans le graphe courant)

### C — Sceau de Double Validation Théorique (AI vs Human) 🔴 CRITIQUE
- Sur toutes les arêtes de la Base de Connaissances (Mode 0) et Graphe Projet (Mode 2), zoom > 35% :
- **Score IA (🤖)** : confiance sémantique d'extraction (0-100%)
- **Score Humain (👤/👥)** : validation personnelle (`✓ Validé par moi`) ou consensus communauté (`👥 XX%`)
- **Sceau Consensus Doré** : IA ≥ 85% ET Humain ≥ 90% → arête dorée lumineuse continue
- **Conflit/Rejet (⚠️)** : rejeté personnellement ou communauté < 40% → arête striée rouge discontinue + ⚠️

## 3. Requirements (RFC 2119)
- **A** : Toute connexion auto-générée SHALL afficher son badge de confiance (calcul multi-signaux).
- **B** : Chaque type de relation SHALL avoir un style visuel distinct (7 types).
- **C** : Toute arête SHALL afficher le sceau double validation (IA + Humain) au zoom > 35%.

## 4. Tests
- TC1 : Badge confiance multi-signaux (HIGH/MEDIUM/LOW). | TC2 : Raccourcis V/X + undo 10s. | TC3 : 7 styles d'arêtes distincts + légende auto. | TC4 : Sceau doré si IA≥85 ET Humain≥90. | TC5 : Striée rouge si rejet <40%. | TC6 : Feedback loop rejets (k≥100 → ajustement seuil).
