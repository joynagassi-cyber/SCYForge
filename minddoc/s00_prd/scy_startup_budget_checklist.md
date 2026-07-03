<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
PRD source de vérité — adapter pour cyber beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📊 CHECKLIST BUDGET SAAS — SCY FORGE — Cyber Beachhead MVP

> **PIVOT v2.0** : Cette checklist est adaptée pour le beachhead cyber SOC/blue-team.
> Les tiers consumer (Lite/Pro/Ultra) sont remplacés par des tiers B2B SOC.
> Les fonctionnalités différées (NEURON-CHAINS, ARENA multi-domaines, CHRONICLE) sont exclues du budget MVP.
> Réf : `docs/SCYFORGE_PIVOT_ARCHITECTURE.md` + `docs/SCYFORGE_STRATEGIC_MASTERPLAN.md`

---

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

> **Règle d'or** : Le Beachhead MVP Scenario privilégie le **contenu pré-généré** (MITRE ATT&CK, pack Cyber pack → $0 LLM).
> Les appels LLM ne servent que pour les interactions **Tactical AI live** (chat, hints, re-scénarisation adaptative).
> En worst-case absolu : 50 SOCs × 5 analystes × 300 sessions/mois × ~5K tokens/session = **75M tokens/mois ≈ 75 $/mois max**.

---

## 🧭 TABLE DES MATIÈRES
1. [Estimer les Coûts Initiaux de Démarrage (CapEx)](#1-capex)
2. [Prévoir les Revenus & Tarifs d'Abonnement](#2-revenus)
3. [Détailler les Dépenses d'Exploitation (OpEx)](#3-opex)
4. [Calculer & Analyser le Cash Flow (Burn Rate & Runway)](#4-cashflow)
5. [Planifier les Imprévus (BudgetGuard)](#5-imprevus)
6. [Processus de Révision Budgétaire](#6-revision)
7. [Stratégie de Financement](#7-financement)
8. [Fiscalité & Comptabilité (Dépôts d'État & IRS)](#8-fiscalite)
9. [Conformité & Sécurité (Compliance)](#9-compliance)
10. [Ressources Humaines & Recrutement](#10-rh)
11. [Croissance Produit Post-MVP](#11-croissance)
12. [Suivi des Métriques de Croissance (SaaS KPIs)](#12-metrics)
13. [Service Client & Succès Client](#13-support)
14. [Partenariats, Ventes & Distribution](#14-sales)

---

## 1. Estimer les Coûts Initiaux de Démarrage (CapEx) <a name="1-capex"></a>

Cette section chiffre les dépenses indispensables à engager avant de pouvoir encaisser votre premier dollar de Chiffre d'Affaires.

### ☐ 1.1 Tâches Juridiques & Administratives (Création US C-Corp via Doola)
*   **[COMPLÉTÉ] plan Doola Tax & Compliance** : **1 999,00 $ / an**  
    *Inclut la formation, l'obtention de l'EIN (IRS), l'agent enregistré, l'adresse virtuelle aux US acceptée par Mercury, et les déclarations fiscales de fin d'année (Forms 1120 & 5472).*
*   **[COMPLÉTÉ] Frais de formation d'État Delaware** : **90,00 $** (Paiement unique).
*   **[À FAIRE] Dépôt de marque USPTO (Double Classe)** : **700,00 $**  
    * *Classe 42 (Web/SaaS)* : 350 $  
    * *Classe 9 (App mobile & Desktop installées localement)* : 350 $  
    *Note : Recommandé de déposer les deux classes dès le départ pour éviter de recommencer la procédure.*
*   **[COMPLÉTÉ] CGU & Politique de Confidentialité** : **0,00 $**  
    *Génération gratuite via les outils conformes Termly ou iubenda avec branding initial.*
*   **[REPORTÉ] Pacte d'actionnaires (Shareholders Agreement)** : **0,00 $**  
    *Inutile au stade de solo-founder. À prévoir uniquement lors de l'intégration d'associés ou d'investisseurs (budget estimé : 550 $ à 1 070 $).*
*   **[COMPLÉTÉ] Ouverture de compte bancaire professionnel** : **0,00 $** (Ouverture gratuite d'un compte Mercury avec bonus de cashback de +150 $ intégré au dashboard Doola).

### ☐ 1.2 Tâches de Développement Initial du Produit (MVP via Agentic SDLC)
Pour estimer le coût réel du code source de SCY Forge développé par des agents autonomes (*Spec-Driven Development*), nous traduisons l'effort en volume de tokens LLM consommés (avec un taux moyen de 85% de Prompt Caching) :
*   **Intégration UI/UX & CSS** (5 000 LOC sur Claude Sonnet 4.6) : **4,46 $** (1.25M de tokens).
*   **Développement Backend** (15 000 LOC sur Claude Opus 4.8 & Sonnet 4.6) : **16,04 $** (3.75M de tokens).
*   **Développement Frontend** (18 000 LOC sur Claude Sonnet 4.6 & DeepSeek Pro) : **14,77 $** (4.50M de tokens).
*   **Tests E2E & Debugging** (5 000 LOC sur DeepSeek Pro) : **5,00 $** (1.50M de tokens).
*   *Note d'ingénierie : L'architecture de Monolithe Unifié alliée au Prompt Caching de juin 2026 permet de générer 43 000 LOC de qualité industrielle pour un coût d'API LLM dérisoire de **40,27 $**.*

### ☐ 1.3 Infrastructure & Outils Initiaux de Lancement
*   **Achat du Nom de Domaine** (`scyforge.io`) : **35,00 $** (puis 66,00 $ / an).
*   **Email professionnel (Google Workspace - 1 utilisateur)** : **110,00 $ / an** (*contact@scyforge.io*, requis pour valider Stripe & Mercury).
*   **Email transactionnel automatisé (Resend)** : **0,00 $** (Plan gratuit jusqu'à 3 000 emails/mois).
*   **Gestion de projet** : **0,00 $** (Plan gratuit de Linear et Notion en solo-founder).
*   **Environnement de développement (IDEs & Outils)** : **0,00 $** (Utilisation d'outils open-source).

### 🏷️ TOTAL CAPEX ESTIMÉ : 2 974,27 $

---

## 2. Prévoir les Revenus & Tarifs d'Abonnement — Deux Marchés Cumulés <a name="2-revenus"></a>

SCY Forge cible **deux marchés complémentaires** avec la même plateforme :
1. **Pure-players cyber** (SOC teams tech) — personas P-SOC1/P-SOC2/P-DFIR/P-SEL
2. **Corporate IT/Cyber non-tech** (banques, hôpitaux, retail, assurances) — Peak-Opportunity, personas P-RSSI/P-JUNIOR/P-ITM

### ☐ 2.1 Configuration de la Grille d'Abonnement (Deux Marchés)

*   **🟢 Trial (0 $ / 30 jours)** :  
    *Usage* : Jusqu'à 3-5 analysts, 1 Domain Pack (MITRE + 1 secteur), scénarios basiques, Dashboard basique.  
    *Cible* : SOC Manager (pure-player) OU RSSI (corporate). Conversion cible : 40% vers Team.
*   **🔵 Team (5 000 $ / an)** :  
    *Usage* : 5-20 analysts, Pack Cyber MITRE complet + 1 secteur, tous les scénarios, Coverage Map + Gap Detection, export PDF readiness reports.  
    *Cible* : SOC Manager (pure-player) OU RSSI petite équipe (corporate).  
    *Inclut* : Role-based onboarding, Semantic Tree viewer, SMI tracking, mastery evaluations.
*   **🟣 Enterprise (25 000 $ / an)** :  
    *Usage* : 50+ analysts, multi-packs (MITRE + secteurs), custom scenarios, SSO/SAML, API access, priority support, SLA.  
    *Cible* : SOC Manager grande équipe (pure-player) OU RSSI services centraux (corporate).
*   **🏭 Industry (50 000 $+ / an)** :  
    *Usage* : RSSI + tous les employés (200-5000), custom sector pack, B2B2C deployment, phishing simulator, compliance mapping.  
    *Cible* : RSSI entreprises non-tech (banques, hôpitaux, retail, assurances, industries). **Peak-Opportunity unique.**
*   **🔴 Government/Defense (custom)** :  
    *Usage* : On-prem possible, air-gap deployment, accréditations NIST SP 800-53 / DoD 8570.  
    *Phase* : Post-MVP (Phase 3+).

### ☐ 2.2 Métriques de Prévision (Deux Marchés)

*   **Taux de Conversion Trial → Team** : > 40% (les deux marchés)
*   **LTV (Lifetime Value) cible** : 
  - Pure-player Team : **15 000 $** (3 ans avg)
  - Corporate Industry : **150 000 $** (3 ans avg, B2B2C expansion)
*   **CAC (Customer Acquisition Cost) cible** : 
  - Pure-player : < 500 $ par SOC (conference + outreach)
  - Corporate : < 5 000 $ par RSSI (CISO summit + partner SIEM)
*   **Hypothèse de conversion** : 20% trials → Team, 10% → Enterprise/Industry.
*   **MRR cible M6** : 25 K$ (50 SOCs pure-player × mix Team/Enterprise)
*   **MRR cible M18** : 100 K$ (50 SOCs pure-player + 20 entreprises corporate × Industry tier)

<!-- PIVOT-BEACHHEAD: deux marchés cumulés (SOC + Corporate), tiers consumer éliminés -->

### ☐ 2.2 Définir les Métriques de Prévision (Objectif de Lancement à 100 SOCs)

*   **Taux de Conversion Trial → Team** : > 40% (vs 10% consumer)
*   **LTV (Lifetime Value) cible** : > 3 000 $ sur le tier Team (24 mois avg)
*   **CAC (Customer Acquisition Cost) cible** : < 500 $ par SOC (conference + outreach)
*   **Hypothèse de conversion** : 20% des trials convertissent vers Team, 10% vers Enterprise. Churn target < 5%/mois.
*   **MRR cible M6** : 50 K$ (100 SOCs × 5 analysts avg × 49 $)

---

## 3. Détailler les Dépenses d'Exploitation (OpEx) <a name="3-opex"></a>

Cette section regroupe les dépenses récurrentes nécessaires à la livraison du service au jour le jour (lissage mensuel).

### ☐ 3.1 Coût de l'Infrastructure Always-on (Northflank + Sidecars)

Notre architecture backend (Axum + PostgreSQL + Zilliz + SearxNG sidecar) s'exécute de manière optimisée sur Northflank :

*   **`scy-ts-gateway`** (Mastra TS Orchestrator, 0.5 vCPU, 1.0 Go RAM) : **12,00 $ / mois**.
*   **`scy-rust-core`** (Calculs lourds, FSRS, RAG, 1.0 vCPU, 1.5 Go RAM) : **21,00 $ / mois**.
*   **`scy-searxng-sidecar`** (Recherche OSINT / threat intelligence, 1.0 vCPU, 2.0 Go RAM) : **18,00 $ / mois**.
    *Inclut la recherche web sécurisée pour le Field Intel Assistant (BRAIN) et la veille TI des analystes SOC.*
*   **PostgreSQL Addon** (RLS multi-tenant, 1.0 Go RAM, 20 Go) : **20,00 $ / mois**.
*   **Zilliz Cloud Serverless** (Index vectoriel) : **10,00 $ / mois**.
*   **Stockage & Egress** : **12,00 $ / mois**.
*   *Sous-total Infrastructure* : **93,00 $ / mois** (coût fixe stable à 100%).

### ☐ 3.2 Coût des APIs LLM à l'Usage — Beachhead Scenario (Contenu Pré-construit)

> **Règle Beachhead** : Tout le contenu MITRE ATT&CK, playbooks, scenarios, évaluations est **pré-généré et stocké** au moment de l'ingestion du cyber pack. Zéro appel LLM pour la navigation apprenant.

Les appels LLM en Phase MVP ne servent que pour :

1. **Tactical AI Live** (chat contextuel + hints adaptatifs) — Fréquence : ~5 sessions/semaine/learner
2. **Gamification adaptative** (re-scénarisation de scenarios selon performance) — Fréquence : ~1 session/semaine/learner
3. **Certification adapted briefs** (génération PDF personnalisé post-évaluation) — Fréquence : 1x/parcours

*   **Worst-Case Absolu (50 SOCs × 5 analystes × sessions tactiques intensives)** : **75,00 $ / mois**.
    *Hypothèse : 75M tokens/mois × 1$/M tokens (DeepSeek V4 Free)*.
*   **Budget de prévision LLM réservé** : **150,00 $ / mois** (2× worst-case pour marge sécurité).
*   *En pratique, la grande majorité des organisations opèrent à **<$10/mois** en LLM grâce au contenu pré-construit.*

### ☐ 3.3 Frais de Traitement & Sales (S&M, G&A)
### ☐ 3.2bis Frais de Traitement Paiements & Analytics
*   **Frais de traitement Stripe (B2B)** : **2,9% + 0,30 $** par transaction.  
    *(Sur un MRR de 50 K$ à M6, les frais Stripe représentent environ **1 450 $ / mois**.)*
*   **Analytics Produit (PostHog)** : **0,00 $** (Plan gratuit jusqu'à 1M événements/mois — suffisant pour MVP beachhead).
*   **Hébergement Frontend (Vercel)** : **0,00 $** (Plan gratuit pour déploiement React/Vite).
*   **Logiciel de Comptabilité** : **0,00 $** (Inclus dans Doola Tax & Compliance).

---

## 4. Calculer & Analyser le Cash Flow (Burn Rate & Runway) <a name="4-cashflow"></a>

Le Cash Flow represents la différence nette entre vos entrées réelles de trésorerie (abonnements payés) et vos sorties (infrastructure, APIs, taxes).

### ☐ 4.1 Modélisation Budgétaire du MVP (Lancement à M0 → M6)

**M0 (Phase Trials — aucun revenu)**

```
[ Entrées Mensuelles ] = 0 $ (trials gratuits uniquement)
[ Sorties Mensuelles ] = -168,00 $
├─ Infrastructure     = -93,00 $
└─ LLM (réservé)     = -75,00 $

[ BURN RATE MOIS 0 ] = 168,00 $ / mois
[ CASH RUNWAY M0 ]   = Infini (bootstrapped solo-founder, pas de capex rec)
```

**M6 (50 SOCs converties → MRR cible)**

```
[ Entrées Mensuelles (MRR) ]  =  +25 000,00 $ (mix Trial/Team/Enterprise)
  ├─ Trial (30 jours gratuit) = 0 $ (courant)
  ├─ Team ($49/seat, 50 SOCs) = 12 250,00 $
  └─ Enterprise ($149/seat, 25 SOCs) = 12 750,00 $

[ Sorties Mensuelles ]  =  -3 068,00 $
  ├─ Infrastructure       =   -93,00 $
  ├─ APIs LLM             =   -75,00 $
  ├─ Stripe (~2,9%)       =  -725,00 $
  └─ Marketing acquisition = -2 175,00 $ (SOC conferences + outreach)

[ BÉNÉFICE NET MENSUEL M6 ]        =  +21 932,00 $ / mois
[ RUNWAY DEPUIS M0 ]                =  1,4 an de cash runway sur CapEx initial
```

### ☐ 4.2 Métriques de Sécurité financière
*   **Burn Rate M0** : **168,00 $ / mois** (infra + LLM réservé — pas de revenu).
*   **Time to Profitability** : **M2** (premiers trials convertis couvrent OpEx).
*   **Cash Runway estimé (sans VC)** : **>18 mois** sur le CapEx initial de 2 974 $.
*   **Token Bleeding Max Loss** : **<150 $/mois** (BudgetGuard LLM plafonné à worst-case).

---

## 5. Planifier les Imprévus (BudgetGuard Cyber) <a name="5-imprevus"></a>

### ☐ 5.1 Garde-fou Budget LLM (Token Bleeding)
*[PIVOT-BEACHHEAD] Le contenu pré-généré minimise le risque, mais le Tactical AI live nécessite une protection.*
*   **[COMPLÉTÉ] Garde-fou BudgetGuard** : Le backend Rust intègre un middleware qui limite le **budget LLM mensuel par organisation** à 150 $.
*   **[COMPLÉTÉ] Bloqueur par organisation** : Si une SOC franchit la limite, le Tactical AI bascule en mode **Configuration Seulement** (lecture, pas de génération).
*   **[À FAIRE] Alertes globales** : Webhooks quand le budget global LLM franchit 50%/80%/100% du plafond mensuel.

### ☐ 5.2 Sonsoriel : Dépassement Coût Ingestion Cyber Pack
*   **[À FAIRE] Budget ingestion MITRE ATT&CK** : Prévoir **500 $ unique** pour l'ingestion/traitement initial du pack Cyber (MITRE + NIST + Sigma rules + playbooks de référence).
    *Coût one-shot au onboarding de chaque nouvelle SOC — amorti sur le trial gratuit de 30 jours.*

---

## 6. Processus de Révision Budgétaire <a name="6-revision"></a>

### ☐ 6.1 Planifier les Révisions
*   **Réunion budgétaire mensuelle (J+5 du mois suivant)** : Comparer la facture réelle émise par Northflank et nos consoles APIs (Anthropic, DeepSeek) avec les logs de la table `scy_llm_spend_log`.
*   **Ajustement de l'algorithme d'échantillonnage FSRS** : Si le coût d'interrogation de l'assistant de chat BRAIN dérape, appliquer une compression locale plus agressive des invites à l'aide de **LLMLingua-2 (ONNX)** avant l'envoi du contexte au LLM.

---

## 7. Stratégie de Financement <a name="7-financement"></a>

### ☐ 7.1 Choix de la Source de Financement
*   **Modèle retenu : 100% Bootstrapped / Indépendance financière.**  
    *Grâce au levier technologique de l'Agentic SDLC qui ramène le coût de développement initial à moins de 50 $, et au déploiement léger sur Northflank à 112 $/mois, aucun apport en capital externe (VC, business angel) n'est nécessaire au lancement.*
*   **Crédits Cloud (Optionnels)** : Soumettre le dossier de SCY Forge au programme de crédits pour startups de Northflank pour obtenir des remises sur le compute d'infrastructure lors de la phase de croissance.

---

## 8. Fiscalité & Comptabilité (Dépôts d'État & IRS) <a name="8-fiscalite"></a>

Notre Delaware C-Corp exige le strict respect du calendrier fiscal sous peine de pénalités majeures d'exclusion.

### ☐ 8.1 Les Échéances Fiscales du Delaware C-Corp (Incluses dans Doola Tax & Compliance)
*   **Rapport annuel Delaware (avant le 1er mars de chaque année)** : Dépôt obligatoire de **50,00 $** auprès de l'État du Delaware.
*   **Delaware Franchise Tax (avant le 1er mars de chaque année)** : Paiement de **400,00 $** (le minimum légal obligatoire).
    *   <critical>**ALERTE DE SÛRETÉ (Franchise Tax calculation) :** Toujours exiger de votre CPA Doola d'appliquer **la méthode d'évaluation "Assumed Par Value Capital"** lors du dépôt annuel. La méthode par défaut ("Authorized Shares") calcule la taxe sur le nombre brut d'actions de l'entreprise (10 millions), générant une facturation erronée de plus de **85 000,00 $ / an** au lieu des **400,00 $** légitimes.*</critical>
*   **Déclaration Fédérale IRS (avant le 15 avril de chaque année)** : Production et dépôt obligatoire du **Form 1120** (Imposition sur les sociétés) et du **Form 5472** (Obligatoire pour tout fondateur non-résident américain détenant plus de 25% du capital d'une C-Corp).
    *   <critical>**ALERTE DE SÛRETÉ (IRS Form 5472) :** L'omission ou l'erreur de dépôt du formulaire 5472 déclenche une amende immédiate de l'IRS de **25 000,00 $**, non négociable. Ce formulaire est entièrement rédigé et déposé par le CPA de Doola dans votre plan.*</critical>

---

## 9. Conformité & Sécurité (Compliance Cyber) <a name="9-compliance"></a>

[PIVOT-BEACHHEAD] Le beachhead cible des SOC teams et des auditeurs sécurité → compliance cyber-native obligatoire.

### ☐ 9.1 Standards Cyber Applicables
*   **NIST Cybersecurity Framework (CSF) 2.0** : Alignement des Mastery Trees sur les 6 fonctions NIST (Identify, Protect, Detect, Respond, Recover, Govern).
*   **CIS Critical Security Controls (CSC) v8** : Mapping des scenarios APT et playbooks sur les 18 contrôles CIS.
*   **SOC 2 Type II** : À certification post-MVP. Budget estimé **15 000 $** pour l'audit initial + **8 000 $/an** pour la surveillance continue.
*   **ISO 27001** : Nécessaire pour Enterprise/Gov tiers. Budget estimé **25 000 $** pour certification initiale.

### ☐ 9.2 Sécurité Multi-Tenant & ISMS
*   **Isolation données SOC (RLS PostgreSQL)** : Toutes les tables filtrent par `organization_id`. Pas de fuite cross-SOC possible.
*   **Chiffrement at-rest** : PostgreSQL RLS + pgcrypto pour données sensibles (IOC, playbooks internes).
*   **Conformité RGPD/CCPA** : k-anonymat ≥ 10, droit à l'oubli, export données portable.
*   **Seal SaaS / SSO** : À prévoir pour Enterprise tier (SAML 2.0, SCIM provisioning).

---

## 10. Ressources Humaines & Recrutement <a name="10-rh"></a>

### ☐ 10.1 Phase Lancement (Solo-founder)
*   **Ressources Humaines** : **0,00 $**. Le projet s'exécute en solo-founder assisté par agents d'ingénierie et d'assurance qualité.
*   **Phase Croissance (Post-Revenue)** : Prévoir le recrutement de freelances ou d'un premier ingénieur frontend senior lorsque le chiffre d'affaires récurrent (MRR) franchit stablement le seuil des **15 000,00 $ / mois**.

---

## 11. Croissance Produit Post-MVP <a name="11-croissance"></a>

### ☐ 11.1 Évolutions Techniques Planifiées (Phase 2 & 3)
*   **Migration vectorielle sur Qdrant** : Planifiée uniquement si le temps de réponse p99 de recherche vectorielle de pgvector ou Zilliz dépasse **50 ms** sur un volume de plus de **5 millions de nœuds** sémantiques.
*   **Modèles d'Embeddings Multimodaux (ColPali)** : Intégration planifiée en Phase 3 uniquement pour les grands comptes d'entreprises (Enterprise Tier), nécessitant le déploiement de serveurs d'inférence GPU dédiés sur Northflank.

---

## 12. Suivi des Métriques de Croissance (SaaS KPIs) <a name="12-metrics"></a>

Le succès commercial et l'évaluation continue du produit s'appuient sur PostHog pour suivre nos indicateurs de performance clés :

*   **MRR (Monthly Recurring Revenue)** & **ARR (Annual Recurring Revenue)**.
*   **NRR (Net Revenue Retention)** : Objectif > 100% (croissance des revenus de la base d'élèves existante grâce aux upsells des parcours ASCENT supplémentaires).
*   **LTV / CAC Ratio** : Objectif minimum $\ge 3\times$ (modèle sain validé par notre structure de marges unitaires de plus de 80%).

---

## 13. Service Client & Succès Client <a name="13-support"></a>

### ☐ 13.1 Outils & Canaux de Support
*   **Base de connaissances socratique** : Intégrée nativement dans la documentation du produit (Notion/GitBook gratuit) pour permettre l'auto-résolution des pannes par les étudiants.
*   **Support de premier niveau** : Géré asynchronement par email (`contact@scyforge.io`) et centralisé gratuitement dans un outil de ticketing open-source.

---

## 14. Partenariats, Ventes & Distribution <a name="14-sales"></a>

### ☐ 14.1 Canaux de Distribution Ingrédients
*   **Canaux de distribution SOC** :
    *   **Cybersecurity conferences** (RSA, Black Hat, DEF CON, SANS) : ~2 000 $/événement (booth + flyers + meetup sponsorships). **Budget cible M0-M6** : 10 000 $.
    *   **SOC Manager newsletters & LinkedIn outreach** : 0 $ (cold outreach + content marketing organique).
    *   **Splunk/Sentinel/MSFT partner programs** : 0 $ (co-marketing avec SIEM vendors — pas de frais d'entrée).
*   **Programme de référence SOC-to-SOC** : Chaque SOC référente obtient **1 mois gratuit** par conversion. Cost-of-acquisition indirect : 49 $/seat.
*   ~~**Canaux créateurs (B2B Creator Console)**~~ → **ÉLIMINÉ du MVP**. Retour Phase 3 (PIVOT_ARCHITECTURE §3).
*   ~~**Canaux consumer**~~ → **ÉLIMINÉ**. SCY Forge beachhead ne vend pas au consommateur final.

---

*Document restructuré, finalisé et validé conformément au modèle financier et d'infrastructure de SCY Forge de juin 2026.*
