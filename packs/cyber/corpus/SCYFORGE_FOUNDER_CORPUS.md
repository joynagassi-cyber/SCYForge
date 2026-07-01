# SCYFORGE — CYBER FOUNDER CORPUS

## Le corpus fondateur cyber : du contenu rare réel, raffiné en matière de maîtrise

> **Document ID** : PACK-CYBER-FOUNDER-CORPUS-V1
> **Date** : 2026-06-29
> **Statut** : 🟢 PREMIÈRE INSTANCE DU DOMAIN PACK — données réelles extraites
> **Pack** : `cyber` v0.1.0 — implémente `CorpusProvider` + alimente `OntologyProvider`
> **Frontière respectée** : ce document vit dans `packs/cyber/`, jamais dans le cœur (cf. `SCYFORGE_DOMAIN_PACK_CONTRACT.md`)

---

## 0. Méthode (pourquoi ce corpus n'est pas inventé)

Le contenu ci-dessous a été **extrait de dépôts réels clonés** (pas généré de mémoire) :

- **SigmaHQ** cloné (`--depth 1`) : **3136 règles `.yml`** observées dans `rules/`.
- **170 techniques ATT&CK distinctes** réellement couvertes par les tags `attack.tXXXX` des règles.
- **ThreatHunter-Playbook (OTRF)** cloné : hunts Windows réels (`docs/hunts/windows/`) avec structure `Hypothesis / Technical Context / Offensive Tradecraft / Datasets`.

Le raffinage transforme cette matière brute en **objets de maîtrise** que le cœur ASCENT sait consommer via les ports du Domain Pack.

---

## 1. La clé de jointure pivot (confirmée empiriquement) : MITRE ATT&CK

Chaque règle Sigma porte des tags `attack.tXXXX` ; chaque hunt OTRF référence une technique ; chaque plan d'émulation MITRE est structuré par technique. **ATT&CK est donc la clé de jointure naturelle** de tout le pack cyber — confirmé en observant les tags réels.

### 1.1 Distribution réelle des techniques (top, extraite de Sigma)

| Technique ATT&CK | Nom | # règles Sigma (observé) | Signal pour SCYForge |
|---|---|---|---|
| `T1059.001` | PowerShell | 190 | Concept **critique** (forte densité = exécution très surveillée) |
| `T1218` | System Binary Proxy Execution (LOLBins) | 145 | Famille riche → bon candidat « graphe de sous-nœuds » |
| `T1027` | Obfuscated Files or Information | 90 | Concept transversal (évasion) |
| `T1574.001` | DLL Search Order Hijacking | 81 | Persistance/escalade |
| `T1112` | Modify Registry | 81 | Très transversal |
| `T1003.001` | LSASS Memory (credential dumping) | 77 | Concept **vital** (cf. hunt OTRF LSASS) |
| `T1059` | Command & Scripting Interpreter | 76 | Nœud parent de T1059.001 |
| `T1105` | Ingress Tool Transfer | 75 | Command & Control |
| `T1548.002` | Bypass UAC | 56 | Escalade |
| `T1078` | Valid Accounts | 55 | Accès initial / persistance |
| `T1047` | Windows Management Instrumentation (WMI) | 48 | Exécution (cf. hunts OTRF WMI) |
| `T1190` | Exploit Public-Facing Application | 46 | Accès initial |

> **Lecture produit** : la densité de règles n'est pas du bruit — c'est un **signal de criticité opérationnelle**. Une technique fortement couverte par Sigma est une technique qu'un analyste SOC rencontrera souvent → elle doit être un **nœud de maîtrise prioritaire** et un **concept à rétention forte** (RetentionPolicy).

### 1.2 Distribution réelle par tactique (extraite de Sigma)

| Tactique | # occurrences (observé) | Implication graphe de maîtrise |
|---|---|---|
| Execution | 796 | Tronc commun de l'onboarding SOC |
| Persistence | 729 | Deuxième pilier |
| Discovery | 247 | Phase intermédiaire |
| Impact | 154 | Scénarios de crise (ARENA) |
| Collection | 110 | Pré-exfiltration |
| Exfiltration | 77 | Fin de kill chain |
| Reconnaissance | 23 | Amont |

---

## 2. Raffinage : schéma de transformation `source brute → objet de maîtrise`

Toute ressource cyber passe par le même pipeline de raffinage, aligné sur les ports du Domain Pack :

```
SOURCE BRUTE                 RAFFINAGE                         OBJET DE MAÎTRISE (cœur)
────────────                 ─────────                         ───────────────────────
Règle Sigma (.yml)      →    extraire title/desc/tags/    →    Concept + Node (domain_refs:
                             falsepositives/level              [{mitre_attack, T1059.001}])
                                                          →    Carte de rétention "détection"
                                                          →    Exercice "pourquoi/faux positif"

Hunt OTRF (.md)         →    extraire Hypothesis /         →    Node de maîtrise "threat hunting"
                             Technical Context /                + Arbre de décision de hunting
                             Offensive Tradecraft

MITRE Emulation Plan    →    séquence d'actions APT        →    Scenario (branches + scoring) ARENA

CISA IR Playbook        →    workflow d'escalade           →    Role parcours + runbook séquencé
```

---

## 3. Exemples réels raffinés (échantillon vérifiable)

### 3.1 Exemple — Règle Sigma réelle → objets de maîtrise

**Source brute réelle** (`rules/windows/process_creation/.../7zip_compress_dump.yml`) :

```yaml
title: 7Zip Compressing Dump Files
description: Detects execution of 7z to compress a ".dmp"/".dump" file,
             which could be a step in dump file exfiltration.
tags:
  - attack.collection
  - attack.t1560.001     # Archive via Utility
detection:
  selection_img: { Image|endswith: ['\7z.exe','\7za.exe','\7zr.exe'] }
  selection_extension: { CommandLine|contains: ['.dmp','.dump','.hdmp'] }
  condition: all of selection_*
falsepositives:
  - Legitimate use of 7z to compress WER ".dmp" files for troubleshooting
level: medium
```

**Raffiné par le Cyber Pack en :**

- **Concept** : « Archivage d'un dump mémoire avant exfiltration » → `domain_refs: [{mitre_attack, T1560.001}]`, criticality = medium.
- **Node de maîtrise** : « Reconnaître la collecte/compression de credentials avant exfiltration ».
- **Carte de rétention (FSRS)** : Q: *« Quel comportement de 7-Zip trahit une préparation d'exfiltration de dump ? »*
- **Exercice de discernement (le vrai différenciateur vs quiz)** : *« Un admin compresse un `.dmp` de Windows Error Reporting pour un ticket support. Alerte ou faux positif ? Justifie. »* → réponse ancrée dans le champ `falsepositives` réel de la règle. **C'est exactement ce qu'un quiz NotebookLM ne fait pas : entraîner le jugement sur le faux positif réel.**

### 3.2 Exemple — Hunt OTRF réel → nœud + arbre de décision

**Source brute réelle** (`docs/hunts/windows/170105-LSASSMemoryReadAccess/notebook.md`) :

- **Hypothesis** : *« Adversaries might be accessing LSASS and extract credentials from memory. »*
- **Technical Context** : LSASS stocke tickets Kerberos, hash NTLM, parfois mots de passe clairs (WDigest).
- **Offensive Tradecraft** : Mimikatz `sekurlsa::logonpasswords` ouvre un handle vers LSASS via `OpenProcess`.

**Raffiné par le Cyber Pack en :**

- **Node de maîtrise** : « Détecter l'accès illégitime à la mémoire de LSASS » → `domain_refs: [{mitre_attack, T1003.001}]`, criticality = **vital**.
- **Arbre de décision de hunting** (DecisionScenarioProvider) :
  ```
  Handle ouvert vers lsass.exe ?
    ├─ Process source légitime (AV/EDR connu) ? → baseline → faible suspicion
    └─ Process source inhabituel ?
         ├─ AccessMask inclut PROCESS_VM_READ (0x10) ? → forte suspicion
         └─ Corrélation avec exécution PowerShell/WMI récente ? → escalade L2
  ```
- **Concept vital → RetentionPolicy** : ce nœud reçoit une **pondération de rétention maximale** (un analyste SOC ne doit JAMAIS oublier la lecture mémoire LSASS).

---

## 4. Couverture du corpus fondateur (état v0.1.0)

| Ressource | État | Volume réel observé | Port alimenté |
|---|---|---|---|
| MITRE ATT&CK (pivot) | ✅ clé de jointure adoptée | 170 techniques (via Sigma) | OntologyProvider |
| SigmaHQ | ✅ cloné, distribution analysée | 3136 règles | CorpusProvider, RetentionPolicy |
| ThreatHunter-Playbook | ✅ cloné, hunts Windows analysés | ~26 hunts Windows | DecisionScenarioProvider |
| MITRE Emulation Plans | 🔵 à intégrer (P1) | — | DecisionScenarioProvider (ARENA) |
| CISA IR Playbooks | 🔵 à intégrer (P1) | — | RoleTaxonomyProvider |
| Hatchepsoute Sigma | 🔵 densification (P2) | — | CorpusProvider |

---

## 5. Différence NotebookLM — rappel ancré dans ce corpus

NotebookLM, sur les mêmes fichiers, produirait : un résumé d'une règle Sigma, une réponse à « qu'est-ce que LSASS ? », peut-être un quiz factuel.

Le Cyber Pack de SCYForge produit, sur les **mêmes** fichiers :
- un **nœud de maîtrise relié à ATT&CK** dans un graphe par rôle,
- une **carte de rétention** planifiée dans le temps (l'analyste ne l'oublie pas dans 3 mois),
- un **exercice de discernement sur le faux positif réel** de la règle,
- un **arbre de décision de hunting** exécutable sous pression,
- une **pondération de criticité** (vital vs medium) qui pilote la rétention.

**Même matière première. NotebookLM dépose la compréhension ; le Cyber Pack + ASCENT produisent l'autonomie mesurable.**

---

## 6. Prochaines étapes du pack

1. **OntologyProvider** complet → `SCYFORGE_CYBER_ONTOLOGY.md` (graphe ATT&CK + relations parent/enfant T1059 → T1059.001, etc.).
2. **RoleTaxonomy** : analyste SOC L1 / L2 / Threat Hunter / IR → sous-graphes requis.
3. **DecisionScenarios** : dériver 3 scénarios ARENA d'un MITRE Adversary Emulation Plan.
4. **ProofRubric** : barème de proof-of-skill (triage correct + escalade + gestion faux positifs).
5. Densifier le corpus de détection avec Hatchepsoute.

---

*Fin du corpus fondateur v0.1.0. Données réelles extraites de SigmaHQ (3136 règles, 170 techniques ATT&CK) et OTRF ThreatHunter-Playbook. Le pivot est ATT&CK ; le moat est ce que ASCENT en fait.*
