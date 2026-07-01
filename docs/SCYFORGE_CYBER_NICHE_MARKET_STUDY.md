# SCYFORGE — ÉTUDE DE MARCHÉ : NICHE CYBER (SOC / BLUE TEAM ONBOARDING)

## Taille de marché, cibles, et 3 scénarios de revenus pour la rentabilité année 1

> **Document ID** : STRAT-CYBER-MARKET-STUDY-V1
> **Date** : 2026-06-29
> **Statut** : 🔵 ÉTUDE DE MARCHÉ — NIVEAU FONDATEUR / INVESTISSEUR
> **Pendant cyber de** : `SCYFORGE_SALES_NICHE_MARKET_STUDY.md` (même méthode, comparaison directe en §6)
> **Méthode** : chiffres ancrés sur données publiques réelles (citées). Modèle reproductible (calculs dans le repo).

---

## 0. La douleur cyber : plus aiguë que la vente, mieux financée

| Fait réel | Chiffre | Source |
|---|---|---|
| Pénurie mondiale de talents cyber | **3,4 – 4 millions** de postes non pourvus | [6](https://dataintelo.com/report/cybersecurity-training-market)[8](https://csoonline.com/article/657598/cybersecurity-workforce-shortage-reaches-4-million-despite-significant-recruitment-drive.html/amp) |
| Postes non pourvus aux US seuls | **750 000+** | [2](https://acsmi.org/blogs/cybersecurity-workforce-shortage-a-comprehensive-2025-study) |
| Orgs en sous-effectif cyber | **67 %** | [8](https://csoonline.com/article/657598/cybersecurity-workforce-shortage-reaches-4-million-despite-significant-recruitment-drive.html/amp) |
| Pros cyber envisageant de partir | **~59 %** (stress/burnout) | [2](https://acsmi.org/blogs/cybersecurity-workforce-shortage-a-comprehensive-2025-study) |
| Burnout = erreurs + temps de réponse plus lent | tiers des burnout sur le départ (5× la normale) | [5](https://expel.com/cyberspeak/optimizing-soc-operations/) |
| Coût d'un SOC interne | **> 1 M$/an** | [5](https://expel.com/cyberspeak/optimizing-soc-operations/) |
| Coût moyen d'une data breach (US) | **> 9,5 M$** | [6](https://www.ccslearningacademy.com/cybersecurity-talent-shortages/) |
| Rétention juniors avec onboarding structuré | **+25 %** (Splunk) | [4](https://www.darknet.org.uk/2025/08/cybersecurity-workforce-trends-in-2025-skills-gap-diversity-and-soc-readiness/) |
| Orgs investissant dans la formation comme #1 levier | **72 %** | [8](https://csoonline.com/article/657598/cybersecurity-workforce-shortage-reaches-4-million-despite-significant-recruitment-drive.html/amp) |

**Insight décisif (confirmé par les sources)** : le « gap » n'est pas un gap de débutants — c'est un gap **d'expérience opérationnelle**. Les recruteurs veulent quelqu'un à qui on dit *« voici nos outils »* sans devoir réexpliquer la réponse à incident ni le change management interne [3](https://www.reddit.com/r/cybersecurity/comments/1jydd8s/so_much_skilled_worked_shortage_i_keep_hearing/). **C'est exactement le problème que SCYForge résout** : transformer le savoir opérationnel interne en autonomie réelle de la recrue. La vérité contre-intuitive (le « secret » Thiel) est ici **prouvée par le marché lui-même**.

De plus : la rétention des juniors dépend plus de **l'onboarding structuré et de la sécurité psychologique** que de l'aptitude technique [4](https://www.darknet.org.uk/2025/08/cybersecurity-workforce-trends-in-2025-skills-gap-diversity-and-soc-readiness/), et **MITRE ATT&CK est désormais une exigence de base** [4](https://www.darknet.org.uk/2025/08/cybersecurity-workforce-trends-in-2025-skills-gap-diversity-and-soc-readiness/) — ce qui valide notre choix de pivot d'ontologie (cf. `SCYFORGE_CYBER_ONTOLOGY.md`).

---

## 1. Taille de marché (TAM / SAM / SOM)

| Niveau | Définition | Estimation | Source / hypothèse |
|---|---|---|---|
| **TAM** | Marché mondial de la formation cyber, 2025 | **10,5 – 17,9 Md$** | rapports 2024-25 [6](https://dataintelo.com/report/cybersecurity-training-market)[10](https://www.marketresearchfuture.com/reports/cyber-security-training-market-28628)[1](https://datahorizzonresearch.com/cyber-security-training-market-45361) |
| **SAM** | Formation technique « readiness » / onboarding par rôle SOC & blue team (≈15–25 % du TAM, hors awareness/phishing) | **1,57 – 4,47 Md$** | part technical/role-based |
| **SOM (an 1–3)** | Wedge « savoir cyber interne → autonomie prouvée des recrues » | **1,6 – 45 M$** | 0,1 – 1 % du SAM |

> **Comparaison clé** : le SAM cyber **(1,6–4,5 Md$)** est du même ordre, voire supérieur, au SAM vente (~1–2 Md$). Et il croît à **~14–16,5 %/an** [6](https://dataintelo.com/report/cybersecurity-training-market)[1](https://datahorizzonresearch.com/cyber-security-training-market-45361). Capturer **0,1 % du SAM** = **1,6–4,5 M$ ARR** : largement de quoi être rentable année 1.

### Distinction critique vs le marché « awareness »
Le gros du marché « cybersecurity training » est de l'**awareness/anti-phishing** (KnowBe4, Proofpoint, Cofense) — **ce n'est PAS notre marché**. Notre cible est la **formation technique / readiness opérationnelle** (le segment « technical training », en forte croissance et moins commoditisé). On évite frontalement les géants de l'awareness.

---

## 2. Qui cibler (ICP & acheteurs)

### 2.1 Segments prioritaires (forte douleur + budget + savoir interne critique)

| Segment | Pourquoi prioritaire |
|---|---|
| **MSSP / SOC managé / MDR** | Recrutent et forment en continu, à grande échelle ; onboarding = coût marginal #1 ; **levier de distribution** |
| **BFSI / Finance** | Plus gros vertical de la formation cyber (4,1→9,3 Md$ d'ici 2035 [10](https://www.marketresearchfuture.com/reports/cyber-security-training-market-28628)) ; conformité ; SOC internes larges |
| **Santé** | +71 % d'attaques en 2025, gap de compétences exposé [6](https://dataintelo.com/report/cybersecurity-training-market) ; segment training à plus forte croissance |
| **Grandes entreprises / opérateurs critiques** | SOC internes >1 M$/an, turnover, savoir institutionnel à préserver |
| **Gouvernement / défense** | Mandats réglementaires (NIST CSF 2.0, EU Cyber Act) [6](https://dataintelo.com/report/cybersecurity-training-market) |

### 2.2 Acheteur économique (séquencé)

```
PHASE 1 (beachhead)        PHASE 2 (levier)            PHASE 3 (scale)
Directeur de SOC /         MSSP / MDR                  RSSI / CISO
Manager Blue Team          (revend à ses clients)
douleur op. directe        multiplie l'usage +         standardise readiness,
(astreinte à 3h)           devient canal               budget large, conformité
```

- **Directeur de SOC** : douleur immédiate (recrue improductive 6–9 mois, escalades ratées, burnout d'équipe), budget tooling/formation, cycle court. **Cible #1.**
- **MSSP / MDR** : onboarding à l'échelle = coût marginal #1 → ROI massif + **canal de revente** (ils forment leurs propres recrues ET peuvent proposer la readiness à leurs clients).
- **RSSI** : achat large, conformité, en dernier — **avec les chiffres des phases 1–2** en main.

---

## 3. Modèle de prix (ancré sur le marché réel)

Données réelles :
- SaaS awareness : **10–100 $/utilisateur/an** ; solutions enterprise : **dizaines à centaines de k$/an** [4](https://www.intelmarketresearch.com/cybersecurity-awareness-training-software-market-36265).
- Formation technique / cyber range (Immersive Labs, SANS, Hack The Box B2B) : nettement plus cher que l'awareness.

**Positionnement SCYForge** : plateforme d'**autonomie opérationnelle prouvée** (outcome), pas un abonnement awareness. Modèle **plateforme + par siège**, ACV cible **30 k–90 k$** selon segment. Justification du prix premium : une recrue autonome plus vite + moins d'erreurs de triage = **réduction directe du risque de breach (>9,5 M$)** [6](https://www.ccslearningacademy.com/cybersecurity-talent-shortages/). L'ACV cyber est **supérieur à la vente** (acheteur sécurité, valeur du risque évité plus élevée).

---

## 4. Les 3 scénarios de revenus + rentabilité année 1

**Hypothèses** : structure lean founder-led, EU/FR. Marge brute SaaS élevée. *(Modèle année 1 simplifié, pleine année par client pour la lisibilité.)*

| Paramètre | Conservateur | Base | Agressif |
|---|---|---|---|
| ACV (annuel) | 30 000 $ | 55 000 $ | 90 000 $ |
| Marge brute | 80 % | 83 % | 86 % |
| Coûts fixes an 1 | 250 k$ | 360 k$ | 520 k$ |
| Churn annuel | 8 % | 6 % | 4 % |

### 4.1 Seuils-clés (nombre de clients nécessaires)

| Objectif | Conservateur | Base | Agressif |
|---|---|---|---|
| **Seuil de rentabilité** (net = 0) | **~10 clients** | **~8 clients** | **~7 clients** |
| **CA fort = 1 M$ ARR** | ~33 clients | ~18 clients | ~11 clients |
| **Rentable à ≥40 % de marge nette** | ~21 clients | ~15 clients | ~13 clients |

### 4.2 P&L illustratif année 1

| Scénario | Clients | ARR | Marge brute | Résultat net | Marge nette |
|---|---|---|---|---|---|
| **Conservateur** | 25 | 750 k$ | 600 k$ (80 %) | **+350 k$** | **47 %** |
| **Base** | 25 | 1,38 M$ | 1,14 M$ (83 %) | **+781 k$** | **57 %** |
| **Agressif** | 20 | 1,80 M$ | 1,55 M$ (86 %) | **+1,03 M$** | **57 %** |

### 4.3 Réponse directe à ta question

> **« Combien d'entreprises pour un CA fort, rentable la 1ʳᵉ année à forte marge ? »**

- **Rentabilité dès ~7–10 clients** (mieux que la vente : ~13–16) grâce à l'**ACV plus élevé**.
- **CA fort (≥1 M$ ARR) + forte marge nette (≥40 %)** : **~13 à 21 clients** suffisent (vs ~25–35 côté vente).
- **Chiffre à retenir** : **viser 20–25 clients payants la première année** place SCYForge sur **0,75–1,8 M$ ARR avec 47–57 % de marge nette**.

---

## 5. Concurrence & angle défendable

| Catégorie | Acteurs | Pourquoi ce n'est PAS notre combat |
|---|---|---|
| Awareness / anti-phishing | KnowBe4, Proofpoint, Cofense, Terranova | Marché différent (sensibilisation employés, pas readiness SOC) |
| Cyber ranges / labs | Hack The Box, Immersive Labs, Cyberbit | Entraînent sur du **savoir public générique**, pas le **savoir interne** du client |
| Certifs / cours | SANS, Cybrary, Infosec, EC-Council | Contenu standardisé, pas d'autonomie mesurée sur le contexte privé |

**Angle blanc (le secret) :** personne ne transforme le **savoir opérationnel interne et privé** d'une organisation (SOP de triage, playbooks IR maison, outils internes, chaîne d'escalade) en **autonomie prouvée et mesurée** de SES recrues. Les autres construisent des autoroutes globales ; SCYForge construit le GPS interne. Cet angle est **plus net en cyber qu'en vente** (où le role-play IA existe déjà).

---

## 6. Verdict comparatif : Cyber vs Vente

| Critère | **Cyber (SOC onboarding)** | Vente (sales onboarding) |
|---|---|---|
| TAM | 10,5–17,9 Md$ | 4,9–6,6 Md$ |
| SAM (notre slice) | **1,6–4,5 Md$** | ~1–2 Md$ |
| ACV réaliste | **30–90 k$** | 18–55 k$ |
| Clients pour rentabilité | **~7–10** | ~13–16 |
| Clients pour 1 M$ ARR + 40 % net | **~13–21** | ~25–35 |
| Concurrence sur l'angle « savoir interne → autonomie » | **Faible (net)** | Moyenne (role-play existe) |
| Coût d'une erreur de recrue | **Breach >9,5 M$ → urgence** | Quota manqué |
| Cycle de vente | Long (RSSI) mais douleur aiguë | Plus court (VP Sales) |
| Pivot d'ontologie déjà construit | ✅ ATT&CK (697 techniques, repo) | ❌ à construire |

> **Recommandation** : le **cyber est le meilleur beachhead** — SAM plus grand, ACV plus élevé, rentabilité à moins de clients, angle plus net, et **le Cyber Pack est déjà à moitié construit dans le repo** (ontologie, rôles, scénarios APT29). La vente reste un **excellent 2ᵉ Domain Pack** pour le volume et la preuve d'extensibilité. La stratégie optimale : **gagner le cyber d'abord, ouvrir la vente ensuite** — sans réécriture, grâce au contrat Domain Pack.

---

*Fin de l'étude cyber. Marché 10,5–17,9 Md$ ; SAM readiness 1,6–4,5 Md$ ; rentabilité dès ~7–10 clients ; CA fort + forte marge à ~13–21 clients (0,75–1,8 M$ ARR, 47–57 % net). Le marché valide lui-même le secret : le gap est un gap d'expérience opérationnelle, pas de débutants.*
