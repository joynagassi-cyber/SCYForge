# SCYFORGE — ARENA SCENARIOS (DecisionScenarioProvider) + PROOF RUBRIC

## 3 scénarios de décision sous pression dérivés du plan d'émulation MITRE APT29

> **Document ID** : PACK-CYBER-ARENA-APT29-V1
> **Date** : 2026-06-29
> **Statut** : 🟢 PORTS `DecisionScenarioProvider` + `ProofRubricProvider` du Cyber Pack v0.1.0
> **Source réelle** : `center-for-threat-informed-defense/adversary_emulation_library` — **APT29.yaml** (79 étapes extraites, `apt29_chain.json`)
> **Consommé par** : `ARENA (Ag-11)` (simulation) + `SKILL-CERTIFIER (Ag-09)` (preuve)

---

## 0. Pourquoi APT29 et pourquoi des scénarios (pas des quiz)

APT29 (groupe attribué au gouvernement russe, actif depuis ~2008 selon le plan MITRE) a un plan d'émulation **réel, séquencé, ancré ATT&CK**. Sa chaîne réelle (extraite) suit la kill chain :

```
1. INITIAL BREACH      1.A T1036.002 (RTLO Masquerading) → 1.B T1059.001 (PowerShell)
2. RAPID COLLECTION    2.A T1119 (Automated Collection) → discovery massif (T1016/T1033/T1057/T1082/T1087)
                       → 2.B.2 T1041 (Exfiltration over C2)
3. STEALTH + ESCALATE  3.A.2 T1134.001 (Token) → 3.A.3 T1548.002 (Bypass UAC) → 3.B T1112 (Modify Registry)
                       → 3.C T1055 (Process Injection)
4. LATERAL MOVEMENT    4.A.2/4.A.3 T1018 (Remote System Discovery) → 4.B.3 T1070.004 (Indicator Removal)
```

> **La différence ARENA vs quiz** : un quiz demande *« qu'est-ce que T1059.001 ? »*. ARENA met la recrue **dans la nuit du SOC** : *« il est 3h du matin, voici l'alerte, tu as 90 secondes, que fais-tu ? »* — et **score sa décision**, pas sa récitation. C'est la conversion `compréhension → autonomie sous pression` que NotebookLM ne fait structurellement pas.

Chaque scénario est **branché** (l'issue dépend des choix), **chronométré**, et **scoré sur 5 dimensions** (cf. § 4).

---

## 1. SCÉNARIO A — « 3h du matin : la première alerte » (rôle cible : SOC L1)

**Étape APT29 source** : 1.A (T1036.002 RTLO) + 1.B (T1059.001 PowerShell).
**Compétence pivot testée** : discernement vrai/faux positif + escalade propre.
**Chronomètre** : 90 s par décision.

### Déroulé branché

```
INJECT : EDR remonte un processus "cod.3aka3.scr" lancé depuis un .scr, suivi d'un
         powershell.exe avec arguments encodés. L'utilisateur est un commercial.

D1 — Première lecture
  ├─ (a) Classer faux positif (écran de veille .scr courant) ........ ❌ piège RTLO
  ├─ (b) Noter le nom de fichier inversé/suspect (RTLO) et creuser ... ✅
  └─ (c) Escalader immédiatement sans contexte ...................... ⚠️ prématuré

D2 — [si b] PowerShell encodé détecté
  ├─ (a) Décoder le base64, vérifier l'intention .................... ✅ +bonus
  ├─ (b) Killer le process et clore ................................. ⚠️ détruit la preuve
  └─ (c) Ignorer (PowerShell = admin normal) ........................ ❌

D3 — Décision d'escalade
  ├─ (a) Escalader L2 avec : host, user, hash, cmdline, timeline .... ✅
  └─ (b) Escalader L2 « process suspect » sans contexte ............. ⚠️ -contexte
```

**Issue gagnante** : reconnaît le masquerading RTLO, préserve la preuve, escalade avec contexte complet.
**Piège principal** : classer faux positif (le `.scr` paraît anodin) — exactement le risque réel d'un L1.

---

## 2. SCÉNARIO B — « Reconstituer l'histoire » (rôle cible : SOC L2)

**Étapes APT29 source** : 2.A→2.H (collection + discovery massif) + 2.B.2 (T1041 exfiltration).
**Compétence pivot testée** : corrélation temporelle multi-signaux en une seule narration d'attaque.
**Chronomètre** : 5 min (investigation, pas réflexe).

### Déroulé branché

```
INJECT : L1 a escaladé. En 4 minutes sur l'hôte : collection auto (T1119),
         puis rafale de discovery (T1016, T1033, T1057, T1082, T1087),
         puis un flux sortant inhabituel vers une IP externe.

D1 — Lecture de la rafale de discovery
  ├─ (a) Voir un pattern automatisé (vitesse non-humaine) = script .. ✅
  └─ (b) Traiter chaque event isolément ............................ ❌ rate l'histoire

D2 — Le flux sortant
  ├─ (a) Relier collection (T1119) + flux = exfiltration C2 (T1041) . ✅ corrélation clé
  ├─ (b) Flux = mise à jour logicielle légitime .................... ❌ faux négatif grave
  └─ (c) Bloquer l'IP sans documenter .............................. ⚠️ agit mais perd la trace

D3 — Qualification
  ├─ (a) « Incident confirmé : intrusion active avec exfiltration » . ✅
  └─ (b) « Activité suspecte à surveiller » ........................ ⚠️ sous-qualifié
```

**Issue gagnante** : reconstitue collection → discovery automatisé → exfiltration C2 comme **une seule chaîne APT29**, qualifie incident confirmé, déclenche IR.
**Piège principal** : traiter le flux sortant comme légitime (faux négatif = data breach).

---

## 3. SCÉNARIO C — « Confiner sans tout casser » (rôle cible : IR / DFIR)

**Étapes APT29 source** : 3.A (escalade : T1134.001 Token + T1548.002 Bypass UAC), 3.B (T1112 Registry), 3.C (T1055 Injection), 4.x (T1018 + T1070.004 Indicator Removal).
**Compétence pivot testée** : décision sous pression + rigueur procédurale (ordre du runbook, seuils d'escalade).
**Chronomètre** : décisions séquentielles, fenêtre de crise.

### Déroulé branché

```
INJECT : Incident confirmé. L'adversaire a escaladé (UAC bypass), modifié la
         registry, injecté dans un process, et commence un mouvement latéral
         (Remote System Discovery T1018) + efface des indicateurs (T1070.004).

D1 — Priorité immédiate
  ├─ (a) Isoler l'hôte du réseau (couper lateral + C2) ............. ✅ confinement
  ├─ (b) Éteindre l'hôte ........................................... ❌ détruit mémoire/preuve
  └─ (c) Lancer un scan AV complet d'abord ......................... ⚠️ trop lent en crise

D2 — Préservation
  ├─ (a) Capturer mémoire/artefacts AVANT remédiation (T1070 efface) ✅ +bonus
  └─ (b) Nettoyer la persistance tout de suite .................... ⚠️ perte de preuve

D3 — Escalade & notification
  ├─ (a) Escalader selon chaîne (RSSI/CERT) car exfiltration avérée  ✅
  └─ (b) Gérer en interne sans notifier ........................... ❌ viole le playbook/PSSI

D4 — Éradication ordonnée
  ├─ (a) Supprimer persistance (Run/services/DLL) + invalider tokens ✅
  └─ (b) Restaurer backup sans éradiquer .......................... ❌ réinfection
```

**Issue gagnante** : isole d'abord, préserve la preuve avant la course contre `T1070.004`, escalade selon la chaîne, éradique dans l'ordre.
**Piège principal** : éteindre l'hôte (réflexe intuitif mais destructeur de preuve mémoire).

---

## 4. PROOF RUBRIC (ProofRubricProvider) — barème de proof-of-skill

Le `SKILL-CERTIFIER (Ag-09)` ne certifie pas une moyenne de quiz. Il agrège **5 dimensions** mesurées en ARENA + rétention :

| Dimension | Ce qu'elle mesure | Source de mesure | Poids |
|---|---|---|---|
| **Détection** | Reconnaît la technique / l'étape kill chain | choix D1 des scénarios | 20 % |
| **Discernement** | Distingue vrai/faux positif | pièges faux positif/négatif | 25 % |
| **Décision** | Choisit la bonne action sous pression | branches scorées + temps | 25 % |
| **Procédure** | Respecte ordre, escalade, préservation preuve | scénario C (runbook) | 20 % |
| **Rétention** | Maintient la maîtrise dans le temps | FSRS / SMI (APEX) | 10 % |

### Seuils de certification par rôle

| Rôle | Seuil global | Exigences spécifiques |
|---|---|---|
| SOC L1 | SMI ≥ 70 | Discernement ≥ 70 (zéro faux positif grave toléré sur scénario A) |
| SOC L2 | SMI ≥ 75 | Détection + Décision ≥ 75 (corrélation réussie scénario B) |
| Threat Hunter | SMI ≥ 80 | Décision (hypothèse→validation) ≥ 80 |
| IR / DFIR | SMI ≥ 80 | **Procédure ≥ 85** (pas de destruction de preuve, escalade conforme) |

### Règles de disqualification (faits non négociables)

- **Faux négatif sur exfiltration** (scénario B, choix « mise à jour légitime ») → échec de la dimension Discernement quel que soit le reste.
- **Éteindre l'hôte** / **restaurer sans éradiquer** (scénario C) → échec Procédure.
- **Ne pas notifier malgré exfiltration avérée** → échec Procédure (viole PSSI/playbook).

> Ces règles incarnent le `ValidationGuard` : certaines erreurs ne sont pas « -2 points », elles sont **éliminatoires**, car en réel elles causent un dommage irréversible.

---

## 5. Le flywheel se branche ici

Chaque passage en ARENA génère des **données privées** (cf. moat § 6) : *quelle branche la recrue a choisie, où elle a hésité, quel piège l'a eue.* Le `PERFORMANCE-ANALYZER` capte ces erreurs réelles ; le `DRIFT-GUARDIAN` agit avant l'abandon ; et — couche 5 du moat — **les erreurs réelles des recrues d'une organisation** affinent ses scénarios pour les recrues suivantes. NotebookLM, sur le même APT29.yaml, produirait un résumé. ARENA produit un humain qui a **déjà vécu** l'attaque et survécu.

---

*Fin des scénarios v0.1.0. 3 scénarios branchés dérivés du plan d'émulation MITRE APT29 réel (79 étapes), barème proof-of-skill à 5 dimensions, règles éliminatoires. Source : CTID adversary_emulation_library.*
