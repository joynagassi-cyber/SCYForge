<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Agent ag18_conscious_agent DIFFÉRÉ beachhead MVP.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🌐 SCY-AG18-CONSCIOUS-AGENT — SPÉCIFICATION (SPEC)
**ID** : S03_AG18_CONSCIOUS_AGENT_SPEC · **Phase** : V1 · **Réf** : PRD §7.5.17

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
Le **Conscious Agent** est l'agent le plus innovant : il fait des **recherches internet en temps réel** pour adapter le parcours de l'utilisateur à la réalité du marché professionnel 2026.

## 2. Features
- **Recherche web temps réel** au démarrage d'un parcours ASCENT :
  - « Quelles compétences recherchent les entreprises en [domaine] en 2026 ? »
  - « Quels outils IA sont utilisés dans [domaine] ? »
  - « Quel salaire moyen pour [profil] ? »
- **Veille continue** : re-recherche tous les 30 jours
- **Insights intégrés au DAG** : nœuds ajoutés/retirés dynamiquement selon marché
- **Questions ancrées réalité** : références à outils/entreprises/cas d'usage réels 2026
- **Alerte skill gap** : « [compétence] en voie d'automatisation → compétence adjacente plus durable »
- **Coût** : 10 requêtes max/démarrage (~$0.001)

## 3. Stack
- `WebSearchClient` (recherche), `DomainAnalyzer`, `ProfileAdapter`
- Table `scy_domain_contexts` (insights, market_trends, ai_tools_in_domain, in_demand_skills, at_risk_skills, TTL 30j)

## 4. Tests
- TC1 : Recherche web au démarrage parcours (10 requêtes). | TC2 : Insights intégrés au DAG. | TC3 : Alerte skill gap (compétence automatisée). | TC4 : Veille 30j (re-recherche). | TC5 : Coût ≤ $0.001.
