# SCYFORGE — STRATÉGIE LEVÉE DE FONDS & CERTIFICATIONS

## Comment lever et vendre en B2B SANS dépenser une fortune en certifications au début

> **Document ID** : STRAT-FUNDRAISING-CERT-V1
> **Date** : 2026-06-29
> **Statut** : 🔵 MÉMO FONDATEUR — DÉBLOCAGE STRATÉGIQUE
> **Contexte fondateur** : sait pitcher, sait vendre lui-même, sait construire le MVP seul, trésorerie pré-levée **< 5 k€**.
> **Croyance à corriger** : *« je dois avoir TOUTES les certifications pour vendre en B2B et lever »* → **FAUX**, démontré par les données réelles ci-dessous.

---

## 0. La confusion qui te coûte cher (à dissiper d'abord)

Tu mélanges **deux familles de « certifications » totalement différentes**. C'est la source du blocage.

| | **A. Certifs PRODUIT / sécurité** | **B. Certifs CYBER personnelles** |
|---|---|---|
| Exemples | SOC 2, ISO 27001, RGPD/DPA | CISSP, OSCP, CEH, GIAC |
| À qui elles servent | Rassurer l'**acheteur B2B** sur ton logiciel | Prouver TA compétence individuelle |
| Qui les demande | Le service achats/sécurité du client | Un employeur qui t'embauche comme salarié |
| **Nécessaires pour LEVER ?** | **NON** | **NON** |
| **Nécessaires pour le MVP / 1ers pilotes ?** | **NON** | **NON** |
| **Nécessaires pour scaler en enterprise ?** | Oui, mais **plus tard et pas toutes** | **JAMAIS** (tu es éditeur, pas prestataire) |

> **Le point qui te libère** : tu construis un **produit logiciel** (un éditeur SaaS). Tu n'es **pas** un consultant cyber qui vend ses heures. Donc les certifs **personnelles** (CISSP, OSCP…) ne te sont **jamais demandées par un client ni par un investisseur**. Tu peux les rayer de ta liste de soucis. Définitivement.

Reste donc seulement la famille A (produit). Et là aussi, la réalité est bien plus douce que tu ne le crois.

---

## 1. Pour LEVER DES FONDS : zéro certification requise

Les investisseurs early-stage financent **3 choses** — aucune n'est une certification :

```
1. ÉQUIPE      → toi : pitch + vente + build MVP solo = profil fondateur fort
2. MVP          → démontre que la techno (ASCENT, le Cyber Pack) fonctionne
3. TRACTION     → LOIs, lettres d'intérêt, design partners, pilotes mesurés
```

Ce qui remplace les certifications dans un deck de pré-seed :
- **Des LOIs (Letters of Intent)** ou des engagements verbaux de Directeurs de SOC : *« si ça marche, on achète »*.
- **1–3 design partners** qui testent le MVP sur leur vrai corpus interne.
- **La page de chiffres du protocole A/B** (cf. `SCYFORGE_THIEL_ACTION_MEMO.md` §1) : time-to-autonomy réduit, prouvé.

> Ton avantage est ÉNORME ici : la plupart des fondateurs early-stage doivent payer un commercial et un dev. **Toi tu pitches, tu vends ET tu codes le MVP.** C'est exactement le profil « founder-market fit » que les investisseurs adorent. Tu n'as pas un problème, tu as un atout rare.

---

## 2. Pour VENDRE en B2B : la vérité chiffrée sur SOC 2

### 2.1 SOC 2 n'est PAS une obligation, et pas un blocage au début

Faits réels (sources) :
- SOC 2 **n'est pas une loi** — c'est exigé seulement quand un prospect « must-win » refuse de signer sans [5](https://www.reddit.com/r/startups/comments/1dol5z8/do_i_need_soc2_compliance/).
- On **peut closer des deals sans SOC 2** au début, surtout si le produit est critique [3](https://www.reddit.com/r/ycombinator/comments/1n7qmvl/soc_2_for_b2b_startups/).
- En phase de discussion, dire *« audit SOC 2 en cours, rapport prévu pour [date] »* suffit souvent à avancer [4](https://www.trycomp.ai/hub/soc-2-checklist-for-saas-startups).
- Le vrai risque sans SOC 2 = **pertes silencieuses** (le service sécurité te filtre sans te le dire) [3](https://www.reddit.com/r/ycombinator/comments/1n7qmvl/soc_2_for_b2b_startups/) — c'est un sujet de **scale**, pas de **démarrage**.

### 2.2 Coûts & délais réels (pour planifier, pas pour paniquer)

| Étape | Coût réel | Délai | Quand le faire |
|---|---|---|---|
| **Security questionnaire + Trust page** | **~0 €** (ton temps) | jours | **Dès maintenant** |
| **SOC 2 Type 1** (snapshot de design) | 5–25 k$ (bas de gamme ~10–15 k$ avec plateforme) | 4–12 semaines | **Quand un 1er deal le réclame** |
| **SOC 2 Type 2** (efficacité dans le temps) | 15–50 k$+ | 6–12 mois (période d'observation) | **Après la levée / 1ers revenus** |
| Pen test (souvent demandé) | 8–30 k$ | ponctuel | Avec le Type 2 |

Sources : [1](https://promise.legal/guides/soc2-roadmap)[2](https://www.trycomp.ai/hub/soc-2-cost-breakdown)[8](https://soc2auditors.org/soc-2-audit-cost/)[7](https://www.skedda.com/insights/soc-2-type-2).

> **Conclusion** : avec **< 5 k€**, tu ne paies **aucun audit maintenant** — et c'est la bonne décision. Le SOC 2 se paie avec **l'argent du 1er client ou de la levée**, jamais avec ton épargne perso avant d'avoir une preuve de demande.

---

## 3. Le substitut gratuit du SOC 2 au démarrage : le « Trust Package »

Avant tout audit, tu peux répondre à 90 % des questions sécurité d'un prospect avec des documents que tu rédiges toi-même, **gratuitement** :

| Élément du Trust Package | Coût | Effet |
|---|---|---|
| **Trust page** sur ton site (politique sécu, chiffrement, hébergement) | 0 € | Signal de sérieux dès la 1ʳᵉ visite [3](https://www.reddit.com/r/ycombinator/comments/1n7qmvl/soc_2_for_b2b_startups/) |
| Réponse standardisée au **security questionnaire** | 0 € | Débloque l'évaluation achats |
| **DPA / clauses RGPD** (modèle) | 0–faible | Indispensable en UE, peu coûteux |
| **Politique de sécurité** écrite (basée sur les contrôles SOC 2) | 0 € | Montre que les contrôles existent déjà |
| **Roadmap conformité** : « SOC 2 Type 1 prévu à [date] » | 0 € | Suffit souvent à avancer [4](https://www.trycomp.ai/hub/soc-2-checklist-for-saas-startups) |
| **Déploiement on-prem / VPC** pour clients sensibles | technique | Contourne certaines exigences (la donnée ne sort pas) |

> Astuce architecture : SCYForge ingère du **savoir interne sensible** (SOP cyber). Proposer un **déploiement isolé chez le client** (le pack tenant-isolé du contrat Domain Pack) transforme une objection sécurité en **argument de vente**.

---

## 4. Le plan séquencé (trésorerie < 5 k€)

```
PHASE 0 — AUJOURD'HUI (coût ~0 €)               ← tu es ici
  • Construire le MVP solo (Cyber Pack + ASCENT, déjà bien avancé dans le repo)
  • Rédiger le Trust Package (gratuit)
  • Pitcher 10–20 Directeurs de SOC → obtenir 2–3 LOIs / design partners
  • Lancer 1 pilote A/B mesuré → produire la page de chiffres

PHASE 1 — LEVÉE PRE-SEED (avec MVP + LOIs + chiffres, AUCUNE certif requise)
  • Deck : équipe (toi) + MVP + traction + marché (études cyber/vente déjà faites)
  • Objectif : lever de quoi financer SOC 2 + 1ers recrutements

PHASE 2 — POST-LEVÉE / 1ers REVENUS (financé par la levée, pas ton épargne)
  • SOC 2 Type 1 (~10–15 k$) quand un deal le réclame
  • Puis SOC 2 Type 2 + pen test pour scaler en enterprise

PHASE 3 — SCALE
  • ISO 27001 si clients EU/internationaux l'exigent
  • Renouvellement annuel Type 2 (~75–90 % du coût initial)
```

**Règle d'or de trésorerie** : *aucune certification payante avant d'avoir soit (a) un client qui la réclame pour signer, soit (b) l'argent de la levée.* Ton épargne < 5 k€ va au MVP et à l'obtention de LOIs, pas à un audit anticipé.

---

## 5. Ce que tu dis à un prospect qui demande « vous êtes SOC 2 ? » (script)

> *« Pas encore certifiés — on est en phase de design partners. Voici notre Trust page, notre politique de sécurité et nos clauses RGPD. Pour vos données sensibles, on peut déployer en environnement isolé chez vous, donc rien ne sort de votre périmètre. Le SOC 2 Type 1 est sur notre roadmap pour [date], et on le lance dès qu'un partenaire comme vous s'engage. »*

Ce discours est **honnête, crédible et désamorce l'objection** — et c'est exactement ce que les guides recommandent [4](https://www.trycomp.ai/hub/soc-2-checklist-for-saas-startups)[2](https://grsee.com/resources/soc/soc-2-for-startups-an-essential-guide-to-compliance/).

---

## 6. Synthèse : tu n'as pas le problème que tu crois

| Ta crainte | Réalité |
|---|---|
| « Je dois TOUTES les avoir » | Non — la plupart jamais, le reste plus tard et progressivement |
| « Les certifs cyber perso (CISSP…) sont trop chères » | Tu n'en as **jamais** besoin (tu es éditeur, pas consultant) |
| « Je dois être SOC 2 pour vendre » | Non au début ; un Trust Package gratuit suffit pour les 1ers deals |
| « Je dois être certifié pour lever » | Non — équipe + MVP + traction, pas de certif |
| « Je n'ai pas l'argent (<5 k€) » | Parfait : le SOC 2 se paie avec l'argent du 1er client / de la levée |

> **Le vrai goulot n'est pas les certifications. C'est : un MVP solide + 2–3 design partners + une page de chiffres.** Tout cela, tu peux le produire avec ton temps et tes compétences actuelles, pour ~0 €. Les certifications suivront, financées par le succès, pas par ton épargne.

---

*Fin du mémo. Pour lever : équipe + MVP + traction (zéro certif). Pour vendre au début : Trust Package gratuit + SOC 2 Type 1 quand un deal le réclame. Les certifs cyber personnelles : inutiles, tu es éditeur. Ne paie jamais un audit avant d'avoir une preuve de demande.*
