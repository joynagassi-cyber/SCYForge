# SCYFORGE — CYBER ONTOLOGY (OntologyProvider)

## L'ontologie cyber : le graphe de maîtrise ancré sur MITRE ATT&CK

> **Document ID** : PACK-CYBER-ONTOLOGY-V1
> **Date** : 2026-06-29
> **Statut** : 🟢 PORT `OntologyProvider` du Cyber Pack v0.1.0 — données réelles
> **Pivot** : `mitre_attack` (déclaré dans `pack.manifest.json`)
> **Frontière** : vit dans `packs/cyber/`, jamais dans le cœur (cf. `SCYFORGE_DOMAIN_PACK_CONTRACT.md`)
> **Artefacts machine-readable** : `attack_hierarchy.json`, `attack_density.json`

---

## 0. Ce que fournit ce port

L'`OntologyProvider` répond à la question que pose le cœur : *« Quels sont les concepts du domaine et comment se relient-ils ? »*

Il fournit trois structures, toutes ancrées sur ATT&CK :

1. **La hiérarchie parent/enfant** (technique → sous-techniques) — ex. `T1059 → T1059.001`.
2. **L'ordre kill chain** (tactiques) — la séquence temporelle d'une intrusion.
3. **Les relations de graphe** que `DAG-ARCHITECT (Ag-03)` utilise pour construire le DAG de maîtrise.

> Toutes les données ci-dessous sont **extraites du bundle STIX officiel `mitre/cti`** (enterprise-attack) et de SigmaHQ — pas inventées. Totaux observés : **697 techniques, dont 475 sous-techniques (222 techniques parentes).**

---

## 1. Le modèle d'ontologie (4 niveaux + relations)

```
TACTIC (le « pourquoi » — objectif adverse)
   │  ex. Execution, Persistence, Credential Access...
   ▼
TECHNIQUE (le « comment » — méthode)            ←── nœud parent
   │  ex. T1059 Command and Scripting Interpreter
   ▼
SUB-TECHNIQUE (le « comment précis »)            ←── nœud enfant
   │  ex. T1059.001 PowerShell
   ▼
PROCEDURE (instance concrète observée)
      ex. APT29 utilise PowerShell pour démarrer un agent
```

### 1.1 Les 5 types de relations du graphe

| Relation | Sens | Source de vérité | Usage SCYForge |
|---|---|---|---|
| `is_subtechnique_of` | enfant → parent | dotted-id ATT&CK (`T1059.001` → `T1059`) | hiérarchie du DAG |
| `belongs_to_tactic` | technique → tactique | `kill_chain_phases` STIX | colonnes kill chain |
| `precedes` | tactique → tactique | ordre kill chain MITRE | séquence d'apprentissage |
| `detected_by` | technique → règle Sigma | tags `attack.tXXXX` | rétention + exercices |
| `hunted_by` | technique → hunt OTRF | référence technique | arbres de décision |

Ces relations sont **génériques côté cœur** : elles s'expriment via `node.domain_refs[]` + des arêtes de graphe. Le cœur ne sait pas ce qu'est `T1059` ; il sait qu'un nœud A `is_subtechnique_of` un nœud B.

---

## 2. La hiérarchie parent/enfant (données réelles)

### 2.1 Exemple complet et réel : la famille T1059

`T1059 — Command and Scripting Interpreter` (tactique : **execution**) possède **13 sous-techniques réelles** dans ATT&CK :

| ID | Nom | Tactique |
|---|---|---|
| **T1059** | Command and Scripting Interpreter *(parent)* | execution |
| T1059.001 | **PowerShell** | execution |
| T1059.002 | AppleScript | execution |
| T1059.003 | Windows Command Shell | execution |
| T1059.004 | Unix Shell | execution |
| T1059.005 | Visual Basic | execution |
| T1059.006 | Python | execution |
| T1059.007 | JavaScript | execution |
| T1059.008 | Network Device CLI | execution |
| T1059.009 | Cloud API | execution |
| T1059.010 | AutoHotKey & AutoIT | execution |
| T1059.011 | Lua | execution |
| T1059.012 | Hypervisor CLI | execution |
| T1059.013 | Container CLI/API | execution |

**Lecture produit (pédagogique)** : un nœud parent `T1059` enseigne le **concept** (un attaquant exécute du code via un interpréteur). Les sous-nœuds enseignent les **variantes concrètes**. Le `DAG-ARCHITECT` peut :
- soit présenter le parent puis approfondir selon le contexte (ex. environnement Windows → prioriser `T1059.001` PowerShell + `T1059.003` cmd),
- soit élaguer les sous-techniques hors scope (ex. pas de macOS → masquer `T1059.002` AppleScript).

C'est exactement ce que la `RoleTaxonomy` exploite : un analyste SOC L1 Windows n'a pas besoin des 13 — il a besoin des 2-3 pertinentes, mais doit **comprendre le parent**.

### 2.2 Croisement densité de détection (Sigma) × hiérarchie

En croisant la hiérarchie ATT&CK avec la densité réelle de règles Sigma (`attack_density.json`), on obtient une **priorité d'apprentissage data-driven** :

| Technique | Densité Sigma (réelle) | Position graphe | Priorité onboarding |
|---|---|---|---|
| T1059.001 PowerShell | 179 règles | enfant de T1059 | **P0 — vital** |
| T1218 System Binary Proxy (LOLBins) | 135 | parent (≥12 sous-tech.) | **P0 — famille riche** |
| T1027 Obfuscation | 87 | parent | P1 |
| T1574.001 DLL Search Order Hijack | 80 | enfant de T1574 | P1 |
| T1003.001 LSASS Memory | 77 | enfant de T1003 | **P0 — vital (credential access)** |

> **Principe** : la densité de règles Sigma = proxy de fréquence opérationnelle. Plus une technique est détectée par de nombreuses règles, plus l'analyste la rencontrera → plus elle pèse dans le graphe et dans la `RetentionPolicy`.

---

## 3. La kill chain comme ordre d'apprentissage (données réelles)

ATT&CK ordonne les tactiques de façon canonique (le déroulé d'une intrusion). Distribution réelle des techniques par tactique (extraite du STIX) :

| # | Tactique | Techniques (réel) | Rôle dans le parcours SCYForge |
|---|---|---|---|
| 1 | reconnaissance | 46 | Contexte amont (souvent hors SOC L1) |
| 2 | resource-development | 50 | Préparation adverse |
| 3 | initial-access | 22 | **Point d'entrée — début de scénario** |
| 4 | execution | 64 | **Tronc commun onboarding** |
| 5 | persistence | 113 | **Pilier majeur** |
| 6 | privilege-escalation | 96 | Escalade |
| 7 | defense-evasion | (large) | Évasion — transversal |
| 8 | credential-access | 67 | **Vital (LSASS, dumping)** |
| 9 | discovery | 49 | Reconnaissance interne |
| 10 | lateral-movement | 23 | Propagation |
| 11 | collection | 41 | Pré-exfiltration |
| 12 | command-and-control | 45 | Canal C2 |
| 13 | exfiltration | 19 | Sortie de données |
| 14 | impact | 33 | **Crise (ransomware, destruction)** |

**Usage** : la kill chain donne au `LEARNING-CONDUCTOR (Ag-04)` un **ordre pédagogique naturel** : on apprend à détecter dans l'ordre où l'attaque se déroule (accès initial → exécution → persistance → … → impact). Un scénario ARENA suit cette même colonne vertébrale (cf. APT29, § scénarios).

---

## 4. Mapping ontologie → ports consommateurs

| Élément d'ontologie | Agent / brique cœur | Ce qu'il en fait |
|---|---|---|
| Hiérarchie parent/enfant | `DAG-ARCHITECT (Ag-03)` | Structure le DAG (nœuds parents → sous-nœuds) |
| Ordre kill chain | `LEARNING-CONDUCTOR (Ag-04)` | Séquence pédagogique |
| Densité de détection | `APEX/FSRS` + RetentionPolicy | Pondère la criticité / rétention |
| Relation `detected_by` (Sigma) | `NEURON-CHAINS` | Génère cartes + exercices faux positifs |
| Relation `hunted_by` (OTRF) | `ARENA (Ag-11)` | Arbres de décision de hunting |
| `domain_refs[]` | cœur (générique) | Stocke la référence sans connaître ATT&CK |

---

## 5. Garde-fou de frontière

Ce document et ses artefacts JSON contiennent les seuls endroits du projet où des identifiants ATT&CK (`T1059`, etc.) sont légitimes. **Le cœur ne doit jamais les contenir en dur** — il ne manipule que `domain_refs[]` opaques. C'est ce qui permettra à un futur `medical` pack de remplacer ATT&CK par ICD-11 sans toucher au cœur.

---

*Fin de l'ontologie v0.1.0. 697 techniques réelles, hiérarchie T1059 complète (13 sous-techniques), kill chain à 14 tactiques. Pivot = ATT&CK ; relations génériques côté cœur.*
