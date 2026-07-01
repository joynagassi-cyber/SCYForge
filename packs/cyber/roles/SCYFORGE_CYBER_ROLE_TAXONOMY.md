# SCYFORGE — CYBER ROLE TAXONOMY (RoleTaxonomyProvider)

## Les rôles cyber et leurs sous-graphes de maîtrise requis

> **Document ID** : PACK-CYBER-ROLES-V1
> **Date** : 2026-06-29
> **Statut** : 🟢 PORT `RoleTaxonomyProvider` du Cyber Pack v0.1.0
> **Dépend de** : `SCYFORGE_CYBER_ONTOLOGY.md` (graphe ATT&CK) + `attack_density.json`
> **Consommé par** : `GOAL-INTERPRETER (Ag-01)` → traduit « je suis recrue SOC L1 » en sous-graphe à maîtriser

---

## 0. Ce que fournit ce port

Le `RoleTaxonomyProvider` répond à : *« Quels rôles existent et quel sous-ensemble du graphe chacun doit-il maîtriser ? »*

Principe directeur : **on ne fait pas maîtriser tout ATT&CK à tout le monde.** Chaque rôle reçoit un **sous-graphe** taillé sur sa réalité opérationnelle, avec des **niveaux de maîtrise attendus** (Aware / Apply / Master) par technique. C'est l'inverse exact d'un catalogue de cours générique : le parcours est *défini par le poste*.

### Échelle de maîtrise (générique, fournie au cœur)

| Niveau | Sens | Ce que prouve le proof-of-skill |
|---|---|---|
| **AWARE** | Sait que ça existe, sait l'identifier | Reconnaît la technique dans une alerte |
| **APPLY** | Sait agir : trier, escalader, documenter | Prend la bonne décision dans un scénario |
| **MASTER** | Sait chasser, corréler, décider sous pression | Conduit un hunt / une réponse de bout en bout |

---

## 1. Les 4 rôles fondateurs (v0.1.0)

```
                    ┌─────────────────────────────────────────┐
                    │            GRAPHE CYBER COMPLET           │
                    │         (697 techniques ATT&CK)           │
                    └─────────────────────────────────────────┘
                                       │ sous-graphe par rôle
        ┌──────────────┬───────────────┼───────────────┬──────────────┐
        ▼              ▼               ▼               ▼
   ┌─────────┐    ┌─────────┐    ┌──────────────┐  ┌──────────────┐
   │ SOC L1  │    │ SOC L2  │    │ Threat Hunter │  │  IR / DFIR   │
   │ Triage  │ →  │ Investig│ →  │  Proactif     │  │  Réponse     │
   └─────────┘    └─────────┘    └──────────────┘  └──────────────┘
   AWARE+APPLY    APPLY+MASTER   MASTER (hunting)   MASTER (réponse)
   large/peu prof. corrélation   hypothèses         confinement/éradic.
```

---

## 2. SOC Analyst L1 — Triage (le rôle d'entrée)

**Mission** : trier les alertes, distinguer vrai/faux positif, escalader correctement. **Largeur > profondeur.**

| Domaine du sous-graphe | Techniques clés (réelles, data-driven) | Niveau attendu |
|---|---|---|
| Exécution | T1059 + **T1059.001 (PowerShell, 179 règles)**, T1059.003 (cmd) | APPLY |
| LOLBins / proxy execution | T1218 (135 règles, famille riche) | AWARE→APPLY |
| Obfuscation | T1027 (87 règles) | AWARE |
| Credential access (sensibilisation) | T1003 / **T1003.001 LSASS (77 règles)** | AWARE |
| Persistence (bases) | T1547.001 (Run keys), T1543.003 (services) | AWARE |
| Discovery | T1082 (System Info), T1057 (Process) | AWARE |

**Compétence pivot L1** : **le discernement du faux positif.** C'est le cœur du métier de triage et le différenciateur vs un quiz : chaque carte d'exercice s'appuie sur le champ `falsepositives` réel des règles Sigma. *« 7-Zip compresse un .dmp : alerte ou WER légitime ? »*

**Sortie de rôle** : escalade propre vers L2 avec contexte suffisant.

---

## 3. SOC Analyst L2 — Investigation (corrélation)

**Mission** : reprendre les escalades L1, corréler plusieurs signaux, confirmer/infirmer un incident. **Profondeur + corrélation.**

| Domaine | Techniques clés | Niveau |
|---|---|---|
| Credential access | T1003.001 (LSASS), T1003 (OS Cred Dumping) | **APPLY→MASTER** |
| Privilege escalation | T1548.002 (Bypass UAC), T1134.001 (Token), T1055 (Process Injection) | APPLY |
| Defense evasion | T1112 (Modify Registry, 81 règles), T1070.004 (File Deletion) | APPLY |
| Lateral movement | T1021.002 (SMB/Admin Shares) | APPLY |
| Persistence (avancée) | T1574.001 (DLL Hijack), T1053.005 (Scheduled Task) | APPLY |
| WMI | T1047 (48 règles) | APPLY |

**Compétence pivot L2** : **la corrélation temporelle** — relier une exécution PowerShell, un accès LSASS et un mouvement latéral en **une seule histoire d'attaque**. Le `PERFORMANCE-ANALYZER` mesure si la recrue reconstitue la chaîne, pas juste si elle reconnaît une technique isolée.

---

## 4. Threat Hunter — Chasse proactive

**Mission** : formuler des **hypothèses** (sans alerte préalable) et les valider dans la donnée. **Master du raisonnement.**

| Domaine | Source réelle (OTRF hunts) | Niveau |
|---|---|---|
| Hypothèse de hunt | OTRF `Hypothesis` / `Offensive Tradecraft` | MASTER |
| LSASS memory access | hunt OTRF `170105-LSASSMemoryReadAccess` (T1003.001) | MASTER |
| WMI abuse | hunts OTRF `RemoteWMIExecution`, `WMIEventing` (T1047) | MASTER |
| AD replication abuse | hunt OTRF `ADModDirectoryReplication` | MASTER |
| Process injection | hunt OTRF `DLLProcessInjectionCreateRemoteThread` (T1055) | MASTER |

**Compétence pivot Hunter** : **partir d'une hypothèse, pas d'une alerte.** Le sous-graphe est structuré autour des hunts OTRF réels (Hypothesis → Technical Context → Tradecraft → arbre de décision). C'est le rôle qui exploite le plus les arbres de décision de hunting (`hunted_by`).

---

## 5. Incident Responder / DFIR — Réponse

**Mission** : contenir, éradiquer, récupérer, documenter. **Master de la procédure sous pression.**

| Phase (basée sur CISA IR Playbook) | Techniques associées | Niveau |
|---|---|---|
| Détection & analyse | toutes (reconnaître l'étape kill chain) | APPLY |
| Confinement | isolation hôte, coupure C2 (T1071, T1105) | MASTER |
| Éradication | suppression persistance (T1547, T1543, T1574) | MASTER |
| Récupération | restauration, validation | APPLY |
| Post-incident | postmortem (templates → flywheel privé) | MASTER |

**Compétence pivot IR** : **la décision sous pression et la rigueur procédurale.** L'IR ne « reconnaît » pas seulement — il **exécute un runbook** dans le bon ordre, en escaladant selon la chaîne de notification. Le proof-of-skill IR mesure l'ordre, la complétude et le respect des seuils d'escalade.

---

## 6. Progression inter-rôles (le graphe grandit avec la recrue)

```
L1 (AWARE large)  ──maîtrise+temps──►  L2 (APPLY+corrélation)
                                          │
                          ┌───────────────┴───────────────┐
                          ▼                                ▼
              Threat Hunter (hypothèses)         IR/DFIR (réponse)
```

Le `GOAL-INTERPRETER` ne réinitialise pas le parcours à chaque promotion : il **étend le sous-graphe** (les nœuds déjà MASTER restent acquis, FSRS les maintient ; on ajoute les nouveaux domaines). C'est la rétention active qui rend la promotion *cumulative* et non répétitive.

---

## 7. Mapping vers les autres ports

| Élément de rôle | Port / agent | Effet |
|---|---|---|
| Sous-graphe par rôle | `GOAL-INTERPRETER` → `DAG-ARCHITECT` | Construit le DAG taillé au poste |
| Niveau attendu (AWARE/APPLY/MASTER) | `SKILL-CERTIFIER` + ProofRubric | Fixe le seuil de certification |
| Compétence pivot | `ARENA` (DecisionScenario) | Détermine le type de scénario |
| Concepts vitaux du rôle | RetentionPolicy | Pondère l'anti-oubli |

---

*Fin de la taxonomie de rôles v0.1.0. 4 rôles fondateurs (SOC L1/L2, Threat Hunter, IR), sous-graphes ancrés sur la densité réelle Sigma et les hunts réels OTRF. Le parcours est défini par le poste, pas par un catalogue.*
