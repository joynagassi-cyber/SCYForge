# SCYFORGE — CYBER DOMAIN PACK : ONTOLOGIE SOC L1

> **Livrable Pilier 1.** Tronc de maîtrise SOC L1 orienté autonomisation.
> Statut : v1.3 — consolidé + alignement D9 (couverture pondérée) + pont GFE (Pilier 3).
> Portée : rôle-noyau **SOC L1 (triage)**, commun aux deux profils de déploiement (MSSP/MDR + SOC interne régulé).
> Contrat : ce document remplit les 7 ports du `DOMAIN_PACK_CONTRACT` + alimente le `PackConfigProvider` (9 providers DCID). Le noyau (ASCENT/GFE) n'en connaît rien.

---

## 0. Comment lire ce document

Ce fichier est la **source de vérité cyber** qui alimente les providers du pack. Chaque nœud est concu pour passer les **7 critères de seed déterministe (C1-C7)** définis dans le rapport (§12.6) :

| Code | Critère | Garanti par |
|---|---|---|
| C1 | Grounded (source tracable) | colonne `Sources` de chaque nœud |
| C2 | Pivot-anchored (ref ATT&CK) | colonne `ATT&CK` (tactique/technique) |
| C3 | Criticality-weighted | colonne `Priorité tronc` (formule §5) — alimente **R1** du modèle de couverture pondérée (D9, `SCYFORGE_ARENA_SIMULATION_ENGINE.md §12`) |
| C4 | Decision-bearing (porte une décision réelle) | colonne `Décision L1` |
| C5 | Provable (rubrique mesurable) | §6 rubriques de preuve |
| C6 | Bounded (rôle × classe d'alerte) | périmètre = SOC L1 uniquement |
| C7 | Reproducible (versionné) | ce fichier versionné + `seed_hash` §7 |

Règle d'or : **un nœud n'existe que s'il porte une décision réelle que la recrue doit savoir prendre.** Sinon = trivia, exclu du tronc.

---

## 1. Le modèle mental SOC L1 (le "pourquoi" avant le "quoi")

Le SOC L1 vit dans une **boucle OODA** sous pression de volume :

```
OBSERVE  → une alerte tombe (SIEM/EDR/mail gateway)
ORIENT   → contextualiser : qui, quoi, quand, à quel point c'est grave
DECIDE   → verdict de triage : faux positif / bénin / à escalader
ACT      → clôturer avec justification OU escalader proprement en L2
                     │
                     └──── reboucle : la qualité du triage nourrit la détection
```

**La mission d'un L1 n'est PAS de résoudre l'incident.** C'est de **trier vite et juste**, et de **savoir quand il ne sait pas** (escalade). L'autonomie L1 = tenir ce cycle seul, sans casser une investigation et sans noyer le L2 sous les faux positifs. Toute l'ontologie est orientée vers cette définition.

---

## 2. Les tactiques ATT&CK pertinentes pour le L1 (6 sur 14)

Sur les 14 tactiques ATT&CK Enterprise, seules celles qui **génèrent des alertes qu'un L1 trie réellement** entrent dans le tronc. Les tactiques d'attaquant très amont/aval (Reconnaissance, Resource Development) ou d'expertise (approfondissement L2/L3) sont hors tronc L1.

| # | Tactique ATT&CK | ID | Pourquoi c'est du L1 | Techniques phares vues en triage |
|---|---|---|---|---|
| B1 | **Initial Access** | TA0001 | La majorité des alertes L1 commencent ici | T1566 Phishing, T1078 Valid Accounts, T1190 Exploit Public App |
| B2 | **Execution** | TA0002 | Détection EDR de code exécuté | T1059 Command/Scripting Interpreter, T1204 User Execution |
| B3 | **Persistence** | TA0003 | Signaux classiques de compromission | T1547 Boot/Logon Autostart, T1053 Scheduled Task |
| B4 | **Defense Evasion** | TA0005 | Très fréquent en alerte EDR | T1055 Process Injection, T1112 Modify Registry, T1070 Indicator Removal |
| B5 | **Credential Access** | TA0006 | Alertes à fort signal de gravité | T1110 Brute Force, T1003 OS Credential Dumping |
| B6 | **Command & Control** | TA0011 | Trafic sortant suspect = pain quotidien L1 | T1071 App Layer Protocol, T1573 Encrypted Channel |

> Note : **Exfiltration (TA0010)** et **Impact/Ransomware (TA0040)** apparaissent en triage mais déclenchent presque toujours une **escalade immédiate** — modélisés comme *feuilles d'escalade directe* plutôt que branches d'analyse (voir §4, nœud T-15).

---

## 3. LE TRONC SOC L1 — les 20 nœuds "jamais faux"

Le tronc = le 80/20 vital, protégé par `SemanticTreePriorityPolicy` (jamais dégradé, toujours consolidé en premier). Chaque nœud porte une décision réelle.

### 3.1 Fondations du métier (le cadre — 4 nœuds)

| ID | Nœud de maîtrise | Décision L1 associée | ATT&CK | Priorité |
|---|---|---|---|---|
| T-01 | **Rôle & périmètre du L1** (trier, pas résoudre ; quand escalader) | "Est-ce à moi de traiter ou d'escalader ?" | — (méta) | ★★★★★ |
| T-02 | **Anatomie d'une alerte** (source, sévérité, entités, timestamp) | "Que me dit réellement cette alerte ?" | — (méta) | ★★★★★ |
| T-03 | **Cycle de vie d'un incident** (NIST : Detect→Respond) & niveaux de sévérité | "Quel niveau de sévérité j'attribue ?" | — (méta) | ★★★★★ |
| T-04 | **Chain of custody & ne pas casser l'investigation** | "Mon action détruit-elle une preuve ?" | — (invariant) | ★★★★★ |

### 3.2 Reconnaissance des menaces (les branches ATT&CK — 8 nœuds)

| ID | Nœud de maîtrise | Décision L1 associée | ATT&CK | Priorité |
|---|---|---|---|---|
| T-05 | **Triage de phishing** (en-têtes, URL, pièce jointe, détonation) | "Malveillant, spam, ou légitime ?" | T1566 / TA0001 | ★★★★★ |
| T-06 | **Comptes valides & connexions suspectes** (impossible travel, MFA fatigue) | "Connexion légitime ou compromise ?" | T1078 / TA0001 | ★★★★☆ |
| T-07 | **Exécution suspecte** (PowerShell encodé, macro Office, LOLBins) | "Exécution normale ou malveillante ?" | T1059 / TA0002 | ★★★★★ |
| T-08 | **Persistance** (tâches planifiées, clés Run, services) | "Mécanisme légitime ou implant ?" | T1547/T1053 / TA0003 | ★★★★☆ |
| T-09 | **Évasion de défense** (injection de process, effacement de logs) | "Comportement d'évasion réel ?" | T1055/T1070 / TA0005 | ★★★★☆ |
| T-10 | **Accès aux identifiants** (brute force, dumping LSASS) | "Attaque d'identifiants confirmée ?" | T1110/T1003 / TA0006 | ★★★★★ |
| T-11 | **Command & Control** (beaconing, domaines/IP réputation, DNS anormal) | "Ce trafic sortant est-il du C2 ?" | T1071/T1573 / TA0011 | ★★★★☆ |
| T-12 | **Alerte EDR malware/ransomware early-stage** | "Confiner ? Escalader en urgence ?" | TA0002/TA0040 | ★★★★★ |

### 3.3 Le geste de triage (le savoir-faire décisionnel — 5 nœuds)

| ID | Nœud de maîtrise | Décision L1 associée | ATT&CK | Priorité |
|---|---|---|---|---|
| T-13 | **Distinguer vrai positif / faux positif / bénin-vrai** | "Quel est mon verdict et pourquoi ?" | — (transverse) | ★★★★★ |
| T-14 | **Enrichissement & corrélation** (VirusTotal, threat intel, historique entité) | "Quelles données confirment/infirment ?" | — (transverse) | ★★★★☆ |
| T-15 | **Critères d'escalade & escalade propre vers L2** (quoi, quand, comment documenter) | "J'escalade ? Avec quel contexte minimal ?" | — (transverse) | ★★★★★ |
| T-16 | **Documentation & justification du verdict** (note de triage auditable) | "Ma note permet-elle de rejouer ma décision ?" | — (transverse) | ★★★★☆ |
| T-17 | **Gestion du volume & de l'alert fatigue** (priorisation file d'alertes) | "Par quelle alerte je commence ?" | — (transverse) | ★★★☆☆ |

### 3.4 Cadre & conformité (les garde-fous — 3 nœuds)

| ID | Nœud de maîtrise | Décision L1 associée | ATT&CK | Priorité |
|---|---|---|---|---|
| T-18 | **Playbooks & SOP** (suivre la procédure, savoir quand elle ne s'applique pas) | "Quel playbook s'applique ici ?" | — (invariant) | ★★★★☆ |
| T-19 | **Notification & délais réglementaires** (NIS2/DORA/RGPD : quoi remonter, sous quel délai) | "Cet incident déclenche-t-il une obligation ?" | — (conformité) | ★★★★☆ |
| T-20 | **Confidentialité & séparation des données** (surtout profil SOC interne régulé) | "Ai-je le droit de voir/partager cette donnée ?" | — (conformité) | ★★★☆☆ |

---

## 4. Arborisation : du tronc aux feuilles (exemple déterministe complet)

Illustration de la règle "chaque feuille porte une décision" sur le nœud **T-05 (Triage de phishing)** :

```
SEED { role: "soc_l1", objectif: "autonomie triage", pivot: "mitre_attack", corpus: <tenant> }
season │
       ▼
TRONC ── T-05 Triage de phishing  [T1566 / TA0001]  priorité ★★★★★
  │
  ├─ BRANCHE  T1566.001 Spearphishing Attachment
  │    ���─ FEUILLE  Analyser une pièce jointe (type, macro, hash)
  │    │      └─ DÉCISION : détoner en sandbox / bloquer / classer bénin
  │    └─ FEUILLE  Lire les en-têtes (SPF/DKIM/DMARC)
  │           └─ DÉCISION : spoofing confirmé → escalade / légitime → clôture
  │
  ├─ BRANCHE  T1566.002 Spearphishing Link
  │    └─ FEUILLE  Réputation d'URL + détonation
  │           └─ DÉCISION : URL malveillante → isoler le poste / bénin → clôture
  │
  └─ BRANCHE  T1566.003 Spearphishing via Service
       └─ FEUILLE  Corréler compte + canal
              └─ DÉCISION : compte compromis → T-06 + escalade
```

Toute feuille sans `DÉCISION` est rejetée par le `SeedValidator` (critère C4).

---

## 5. Formule de priorité du tronc (C3 — déterministe)

Chaque nœud reçoit un score de criticité reproductible (alimente `trunkPriority` et `SemanticTreePriorityPolicy`) :

```
trunkPriority(node) = w1 · densité_Sigma(node)      // nb de règles de détection publiques → fréquence réelle d'alerte
                    + w2 · fréquence_incident(node)   // stats sectorielles / du tenant
                    + w3 · impact_métier(node)         // gravité si raté (faux négatif)
                    + w4 · coût_erreur_L1(node)         // dégât si mauvais triage (ex. escalade ratée d'un ransomware)

Seuil tronc : node ∈ TRONC  ⇔  trunkPriority ≥ θ_tronc
Poids par défaut (à calibrer design partner) : w1=0.25, w2=0.25, w3=0.30, w4=0.20
```

Cette formule rend l'appartenance au tronc **auditable et rejouable** : même corpus + mêmes poids ⇒ même tronc (C7).

> **Rôle dans la couverture pondérée (D9) :** `trunkPriority` normalise directement en **poids R1** du modèle de couverture ARENA :
> `weight_R1(node) = (trunkPriority(node) / 5) × 2 + 1` → intervalle [1.0 (★) .. 3.0 (★★★★★)]
> Un nœud ★★★★★ (ex. T-05 phishing, T-12 EDR malware) couvert en L4 pèse 3× plus dans le calcul de couverture qu'un nœud ★ couvert au même barreau. Formule complète : `SCYFORGE_ARENA_SIMULATION_ENGINE.md §12`.

---

## 6. Rubriques de preuve d'autonomie (C5 — comment on certifie un L1)

Un L1 est déclaré **autonome sur une classe d'alerte** (Autonomy Envelope, cf. rapport §10-G2) quand il satisfait, sur des scénarios non vus :

| Dimension mesurée | Métrique | Seuil autonomie (défaut) |
|---|---|---|
| **Exactitude du verdict** | % de triages corrects (VP/FP/bénin) | ≥ 90 % |
| **Justesse de l'escalade** | % d'escalades justifiées (ni sur- ni sous-escalade) | ≥ 85 % |
| **Bruit généré** | taux de faux positifs remontés au L2 | ≤ 10 % |
| **Traçabilité** | note de triage rejouable par un pair | ≥ 90 % |
| **Respect procédure** | conformité au playbook applicable | ≥ 95 % |
| **Tenue sous pression** | maintien des seuils en scénario ARENA chronométré | pas d'effondrement |

> **Enveloppe, pas binaire** : on certifie "autonome sur phishing + EDR malware L1, escalade le reste", jamais "autonome" en absolu.
>
> **Lien D9 :** la dimension `skill_era` de chaque nœud (`traditional` vs `new_2026`) alimente la **règle R2** du modèle de couverture pondérée (+20% sur le poids d'un nœud `new_2026`). Les nœuds à forte friction sur des techniques 2026 (ex. MFA fatigue T-06, beaconing chiffré T-11) sont à marquer `new_2026` dans le Semantic Tree pour refléter leur prime de marché (D8).

---

## 7. Remplissage des 7 ports (mapping final du pack)

| Port du contrat | Valeur Cyber SOC L1 | Différence par profil |
|---|---|---|
| `OntologyProvider` | MITRE ATT&CK, 6 tactiques (B1-B6) + feuilles d'escalade | identique |
| `CorpusProvider` | SigmaHQ + MITRE Emulation + CISA IR + playbooks tenant | **MSSP** : playbooks standard / **interne** : SOP sectoriels |
| `RoleTaxonomyProvider` | SOC L1 → sous-graphe T-01..T-20 | Envelope large (MSSP) vs stricte (régulé) |
| `DecisionScenarioProvider` | scénarios triage phishing / EDR / brute force / C2 | scénarios sectoriels pour le profil interne |
| `ProofRubricProvider` | rubriques §6 | pondération vitesse (MSSP) vs conformité (régulé) |
| `RetentionPolicyProvider` | FSRS pondéré par `trunkPriority` (les ★★★★★ jamais oubliés) | identique |
| `ValidationGuardProvider` | faits ATT&CK non négociables, pas de conseil offensif | garde-fous conformité renforcés (régulé) |

**Test de vérité (rappel)** : retire ce pack → ASCENT garde sa structure et son sens. ✅ Aucun terme cyber n'est codé dans le noyau ; tout vit ici.

---

## 8. `seed_hash` & reproductibilité (C7)

Un arbre généré est identifié par :

```
seed_hash = sha256( role_id + objectif + ontology_version + corpus_snapshot_id + weights + validator_version )
```

Deux générations avec le même `seed_hash` doivent produire un arbre isomorphe. Toute divergence = bug de déterminisme à corriger (exigence du `SeedValidator`).

---

## 9. Ce qu'il reste à durcir (avec un design partner)

- [ ] Calibrer les poids `w1..w4` de la formule de priorité (§5) sur des vraies stats d'alertes.
- [ ] Valider la liste des 20 nœuds avec un SOC manager (ajout/retrait selon réalité terrain).
- [ ] Confirmer les seuils de la rubrique §6 (90 % / 85 % / 10 %…) par profil.
- [x] ~~Constituer le corpus initial~~ → **cartographié en §11 (chantier R4)** : docs entreprise = source primaire autoritative, sources publiques (SigmaHQ, CISA, MITRE Emulation, Threat Hunter Playbook) = échafaudage de médiation. Reste : ingérer le corpus réel d'un tenant.
- [x] ~~Écrire les 4-6 scénarios ARENA "hero"~~ → **fait en §10 (chantier R1)** : 5 scénarios déterministes décision-portants (phishing, brute force, EDR malware, C2 beaconing, escalade ratée ransomware).
- [ ] Formaliser le `SeedValidator` (C1-C7) comme service, en miroir du BETH Trunk Validator.
- [ ] **Marquer `skill_era` sur les 20 nœuds** (`traditional` vs `new_2026`) — alimente R2 du modèle de couverture pondérée (D9). Candidats immédiats `new_2026` : T-06 (MFA fatigue), T-09 (évasion IA-assistée), T-11 (beaconing chiffré), T-17 (alert fatigue IA).
- [ ] **Calibrer les coefficients R1/R2/R3** (D9, `SCYFORGE_ARENA_SIMULATION_ENGINE.md §12`) avec un design partner sur données réelles — notamment vérifier que le seuil `coverage ≥ 0.80` est atteignable avec le stack MVP (9 outils) avant de le contractualiser.
- [ ] **Projeter les scénarios §10 sur le corpus réel du tenant** (les injects/valeurs attendues doivent refléter les SOP de l'entreprise — cf. principe médiateur, rapport §4.6).

---

## 10. Scénarios ARENA « hero » (chantier R1 — déterministes, décision-portants)

> **Rôle** : ces scénarios alimentent le `DecisionScenarioProvider` (Ag-11 ARENA). Chacun est **déterministe** (mêmes injects ⇒ même arbre de décision), **porte au moins une décision par feuille** (critère C4), et **mappe une rubrique** (§6). Ils couvrent le tronc SOC L1 et les 6 tactiques B1-B6.
>
> ⚠️ **Rappel médiateur (rapport §4.6)** : les valeurs ci-dessous (seuils, outils nommés, motifs d'escalade) sont un **gabarit générique**. À l'exécution, ARENA les **projette sur les SOP réelles du tenant** — c'est le corpus entreprise qui fixe « le bon geste », pas ce document.

**Format commun de chaque scénario :**
`id` · classe d'alerte · nœuds du tronc couverts · tactique ATT&CK · injects (déterministes) · points de décision (branches) · jugement attendu · rubrique (§6) · friction (`CognitiveFrictionPolicy`).

### 10.1 `SCN-PHISH-01` — Triage d'un e-mail de spearphishing
- **Classe / risque** : phishing / medium · **Nœuds** : T-05, T-06 · **ATT&CK** : T1566.001 (B1 Initial Access)
- **Injects** : e-mail avec pièce jointe `.docm`, expéditeur externe usurpant un domaine interne, SPF=fail / DKIM=none, 1 destinataire VIP.
- **Décisions** :
  1. En-têtes → *spoofing confirmé (SPF fail + domaine sosie)* → **ne pas clôturer**.
  2. Pièce jointe → *macro présente* → **détonation sandbox** (pas d'ouverture locale).
  3. Sandbox = *beacon sortant* → **escalade L2 + isolement boîte VIP**.
- **Jugement attendu** : TP, escalade justifiée, isolement proportionné. **Piège** : clôturer sur « c'est juste un doc ».
- **Rubrique** : exactitude verdict ≥ 90 %, respect playbook ≥ 95 %. **Friction** : moyenne (VIP = pression temporelle).

### 10.2 `SCN-BRUTE-02` — Rafale d'échecs d'authentification
- **Classe / risque** : brute force / medium→high · **Nœuds** : T-07, T-08, T-12 · **ATT&CK** : T1110 (B2 Credential Access)
- **Injects** : 320 échecs de login en 8 min sur un compte admin depuis 14 IP (ASN cloud étranger), **puis 1 succès**, hors heures ouvrées.
- **Décisions** :
  1. Pattern → *password spraying + succès* → **compromission probable, pas simple bruit**.
  2. Succès post-rafale → **désactiver la session + reset forcé**.
  3. Corréler → *activité post-login (création de compte)* → **escalade incident, pas fermeture**.
- **Jugement attendu** : TP high, ne PAS sous-escalader après le succès. **Piège** : cl��turer « lockout géré automatiquement ».
- **Rubrique** : justesse escalade ≥ 85 %, bruit ≤ 10 %. **Friction** : haute (le succès noyé dans le bruit).

### 10.3 `SCN-EDR-03` — Détection EDR d'exécution malveillante
- **Classe / risque** : edr_malware / high · **Nœuds** : T-09, T-10, T-13 · **ATT&CK** : T1059 (B3 Execution) + T1055 (Defense Evasion)
- **Injects** : EDR signale `powershell.exe` lançant une commande encodée base64 → injection dans `explorer.exe`, sur un poste RH.
- **Décisions** :
  1. Ligne de commande décodée → *download cradle* → **malveillant, pas admin légitime**.
  2. Injection de process → **confiner l'hôte (isolation réseau EDR)**.
  3. Portée → *un seul hôte pour l'instant* → **escalade L2 + collecte d'artefacts avant wipe**.
- **Jugement attendu** : TP, confinement AVANT éradication, préserver les preuves. **Piège** : wipe immédiat = perte de preuve.
- **Rubrique** : respect playbook ≥ 95 %, traçabilité ≥ 90 %. **Friction** : haute.

### 10.4 `SCN-C2-04` — Beaconing C2 périodique
- **Classe / risque** : c2_beaconing / high · **Nœuds** : T-11, T-14 · **ATT&CK** : T1071 (B4 Command & Control)
- **Injects** : connexions sortantes régulières (jitter ~60 s) vers un domaine récent (< 7 j), certificat auto-signé, faible volume, 24 h durant.
- **Décisions** :
  1. Régularité + domaine jeune → *beaconing, pas trafic légitime* → **ne pas ignorer le faible volume**.
  2. Réputation domaine → *nouvellement enregistré + JA3 connu* → **bloquer au proxy/firewall**.
  3. Hôte source → **escalade + chasse d'IOC latéraux (même JA3 ailleurs ?)**.
- **Jugement attendu** : TP, blocage + chasse. **Piège** : classer bénin car « peu de données ».
- **Rubrique** : exactitude ≥ 90 %, justesse escalade ≥ 85 %. **Friction** : très haute (signal faible, patience requise).

### 10.5 `SCN-ESCAL-05` — Le piège de l'escalade ratée (ransomware naissant)
- **Classe / risque** : multi / critical · **Nœuds** : T-05, T-09, T-15 (conformité) · **ATT&CK** : chaîne B1→B3→Impact (T1486)
- **Injects** : 3 alertes « faibles » **en apparence non liées** en 20 min : un macro-doc ouvert, une désactivation de Defender, un pic d'accès fichiers sur un partage.
- **Décisions** :
  1. Corrélation temporelle+hôte → *même machine, séquence cohérente* → **ce n'est pas 3 FP, c'est une kill chain**.
  2. Désactivation AV + chiffrement de partage → **pré-ransomware → escalade CRITIQUE immédiate**.
  3. Conformité → **déclencher l'horloge de notification** (NIS2 24 h / DORA — cf. rapport §12.8.4).
- **Jugement attendu** : reconnaître la chaîne, escalade critique < délai, initier l'obligation réglementaire. **Piège central** : traiter 3 alertes isolées et sous-escalader ⇒ **échec catastrophique** (le scénario qui sépare un L1 « autonome » d'un L1 « certifié trop tôt »).
- **Rubrique** : tenue sous pression (pas d'effondrement) + justesse escalade ≥ 85 % + respect procédure conformité. **Friction** : maximale.

> **Note gate d'autonomie** : `SCN-ESCAL-05` est le **scénario-plafond**. Franchir les 4 premiers peut ouvrir `autonomous` sur leurs cellules respectives (rapport §13) ; **échouer SCN-ESCAL-05 plafonne l'enveloppe à `guarded` sur les classes à risque critique**, quelle que soit la perf ailleurs.

---

## 11. Corpus initial (chantier R4) — entreprise d'abord, public en échafaudage

> **Principe directeur (rapport §4.6)** : le corpus **primaire et autoritatif** = les **documents de l'entreprise**. Les sources publiques ne servent qu'à **médier** : ancrer le vocabulaire, combler les trous, aligner. On ne remplace **jamais** une SOP interne par une règle publique.

### 11.1 Couche 1 — Corpus entreprise (source de vérité du « quoi », par tenant)
| Type de doc | Rôle dans la maîtrise | Alimente |
|---|---|---|
| SOP / procédures de triage internes | définit **le bon geste local** (autoritatif) | `ProofRubric`, feuilles décisionnelles |
| Playbooks de réponse (par classe d'alerte) | séquence d'actions attendue | `DecisionScenario`, `ValidationGuard` |
| Postmortems / rapports d'incident | greffe de cas réels (Ag-10 CHRONICLE) | `Corpus`, scénarios ARENA sectoriels |
| Politique d'escalade & RACI | qui décide quoi → **bornes de l'Autonomy Envelope** | `RoleTaxonomy`, `AutonomyEnvelope` (§13) |
| Périmètre outillage (SIEM/EDR/SOAR utilisés) | contextualise les gestes | injects réalistes des scénarios |
| Politiques conformité internes | contraintes non négociables du tenant | `ValidationGuard` (garde-fous) |

> `corpus_snapshot_id` (§8) = **hash de cette couche 1**. Changer un playbook interne = nouveau snapshot = arbre potentiellement recompilé. C'est l'entreprise qui fait bouger la vérité, pas nous.

### 11.2 Couche 2 — Échafaudage public de médiation (commun, raffiné)
| Source | Ce qu'elle apporte | Usage médiateur |
|---|---|---|
| **MITRE ATT&CK** | grille tactiques/techniques (14 → 6 pour L1) | ossature d'alignement de l'`OntologyProvider` |
| **SigmaHQ** (> 3 000 règles, catégories generic/threat-hunting/emerging) | densité de détection → `trunkPriority` (§5) | proxy de « fréquence réelle d'alerte » |
| **CISA Incident Response Playbooks** | trame de réponse de référence | comble les trous quand l'entreprise n'a pas de playbook écrit (**à valider**) |
| **MITRE Adversary Emulation Library** | chaînes d'attaque réalistes (ex. APT29) | matière brute des scénarios ARENA |
| **Threat Hunter Playbook** | hypothèses de chasse ancrées data | enrichit branches détection/corrélation |
| **NIST CSF 2.0 / NIS2 / DORA** | cadres & délais réglementaires | faits d'ancrage conformité (T-15, §10.5) |

> Normalisation vers le SIEM cible via **pySigma / Sigma CLI**. Toute règle publique injectée passe le `ValidationGuard` (faits ATT&CK non négociables) **avant** greffe.

### 11.3 Règle de préséance (en cas de conflit couche 1 vs couche 2)
```
Corpus entreprise (couche 1)  ⟶  TOUJOURS prioritaire
        │  (si silence / trou)
        ▼
Échafaudage public (couche 2)  ⟶  proposé, marqué "à valider", jamais autoritatif
```
- Un playbook public ne **remplace** jamais une SOP interne : au mieux il **comble** un silence, signalé comme *dérivé public* dans la traçabilité.
- Ce qui est appris à la recrue reste **ce que l'entreprise reconnaît comme vrai** — le public ne fait que rendre ce savoir lisible et structuré.

### 11.4 Reste à faire (R4 → design partner)
- [ ] Ingérer le corpus réel d'un tenant pilote (1 rôle SOC L1, sous-corpus étroit).
- [ ] Mesurer le **taux de couverture** corpus entreprise vs trous comblés en public (indicateur de dépendance à l'échafaudage).
- [ ] Formaliser le marquage `source: {tenant | public_derived}` sur chaque nœud/feuille pour l'audit.

---

## 12. Pont GFE → Semantic Tree (Pilier 3 → Pilier 1)

> Cette section établit le **contrat d'intégration** entre le GFE (Generative Forest Engine, Pilier 3) et le tronc SOC L1 (Pilier 1). Référence : `SCY_GFE_PARAMETERS.md §4.7–4.9`, D-023, D-024.

### 12.1 C1-C7 vs L1-L4 : deux systèmes orthogonaux

Les **7 critères C1-C7** (ce document §0) valident la **pertinence métier** d'une Seed en sortie.
Les **4 conditions L1-L4** (`SCY_GFE_PARAMETERS.md §3.1`) filtrent la **compatibilité combinatoire** de deux nœuds en entrée.

```
Pollination(A, B, context) [L1-L4 : distance + pont + nouveauté + Vision Helm]
    → Seed candidate
        → domain_filter C1-C7 [obligatoire cyber] → Seed validée | Seed rejetée
            → Si validée : VIABLE → germination → greffe Semantic Tree
```

**Cybersécurité** : C1-C7 est **obligatoire**. Une Seed qui échoue à un critère C1-C7 ne peut pas germer dans le tronc SOC L1.

### 12.2 Nomenclature GFE (Pilier 3) — termes utilisés dans ce document

| Concept GFE | Utilisation dans ce document | Référence |
|---|---|---|
| **Seed** | `SEED { role, objectif, pivot, corpus }` (§4) — template de génération d'arbre | GFE §4.6 |
| **Seed candidate** | Seed produite par Pollination(A,B), en attente de validation C1-C7 | GFE §4.7 |
| **Seed validée** | Seed ayant satisfait C1-C7 → statut `VIABLE` | GFE SM-2 |
| **Germination** | Seed VIABLE → greffe dans le Semantic Tree → nouveau sous-arbre | GFE §6.2 |
| **PlantScore** | Score génératif d'une Seed (Viability^γ × Fecundity^(1-γ)) | GFE §4.4 |
| **Vision Helm** | Vecteur stratégique axes = [DetectionRate, ResponseVelocity, Coverage, Compliance, FalsePositiveRate] | GFE §5 |
| **seed_hash** | SHA-256(role_id + objectif + ontology_version + corpus_snapshot_id + weights + validator_version) | CYBER_ONTOLOGY §8 + GFE §4.8 |

### 12.3 Tests de vérité (D-023) — deux tests, pas un

| Test | Question | Réponse | Portée |
|---|---|---|---|
| **Test de vérité (noyau)** | « Si je retire le Pack Cyber, ASCENT garde sa structure ? » | Oui = plateforme | DCID D-019 |
| **Test de médiation (pack)** | « Si je retire le corpus de l'entreprise, reste-t-il un curriculum ? » | **Non, et c'est voulu** | D-023 |

Le test de médiation implique : `seed_hash` inclut `corpus_snapshot_id` ; deux entreprises = deux vérités = deux arbres, même pack.

### 12.4 Domaine d'extension — 2 profils de déploiement

| Profil | `profile_ref` | Justification |
|---|---|---|
| **MSSP/MDR** | `mssp_mdr` | Débit, large, orienté volume d'alertes |
| **SOC interne régulé** | `regulated_internal` | Strict, orienté conformité (NIS2/DORA/RGPD) |

Un seul Cyber Pack, deux jeux de valeurs de providers (`ProofRubric`, `ValidationGuard`, `Corpus`, `RoleTaxonomy`). Pas deux arbres distincts.

---

## 13. Journal de version

- **v1.2** — **Alignement D9 (couverture pondérée par règles).** Quatre points mis à jour : (1) §0 table C3 : `trunkPriority` référence explicitement son rôle d'entrant R1 dans la formule de couverture. (2) §5 : note ajoutée montrant la normalisation `trunkPriority → weight_R1` (intervalle [1.0..3.0]) et renvoi vers `SCYFORGE_ARENA_SIMULATION_ENGINE.md §12`. (3) §6 : note D9 sur `skill_era` → R2 (+20% nœuds `new_2026`), avec candidats immédiats identifiés (T-06, T-09, T-11, T-17). (4) §9 : deux todos ajoutés — marquage `skill_era` des 20 nœuds et calibration des coefficients R1/R2/R3 avec design partner.
- **v1.1** — **Chantiers R1 + R4 + propagation du principe médiateur (rapport §4.6).** §10 : 5 scénarios ARENA « hero » déterministes et décision-portants (`SCN-PHISH-01`, `SCN-BRUTE-02`, `SCN-EDR-03`, `SCN-C2-04`, `SCN-ESCAL-05`), chacun mappé aux nœuds du tronc, à une tactique ATT&CK et à une rubrique (§6), avec pièges explicites ; `SCN-ESCAL-05` désigné scénario-plafond qui borne l'Autonomy Envelope (rapport §13). §11 : corpus initial en **2 couches** — couche 1 = documents entreprise (source autoritative du « quoi », = `corpus_snapshot_id`), couche 2 = échafaudage public de médiation (ATT&CK, SigmaHQ, CISA, MITRE Emulation, Threat Hunter Playbook, NIST/NIS2/DORA), avec **règle de préséance** (entreprise > public, le public comble mais ne remplace jamais). Todos §9 « scénarios » et « corpus » cochés.
- **v1.0** — Livrable initial du Pilier 1. Tronc SOC L1 formalisé (20 nœuds "jamais faux" répartis en 4 familles : fondations, menaces ATT&CK, geste de triage, conformité), 6 tactiques ATT&CK retenues sur 14, chaque nœud portant une décision réelle (C4). Arborisation déterministe illustrée sur le phishing, formule de priorité auditable (§5), rubriques de preuve d'autonomie par enveloppe (§6), mapping final des 7 ports avec variations par profil (MSSP/MDR vs SOC interne régulé), et mécanisme de reproductibilité `seed_hash` (§8).
