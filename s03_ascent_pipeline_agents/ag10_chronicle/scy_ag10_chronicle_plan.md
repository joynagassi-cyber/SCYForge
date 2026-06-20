# 🛠️ SCY-AG10-CHRONICLE — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S03_ASCENT_AG10_CHRONICLE_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

## 1. Flux de Données de l'Agent

```
 [Messages multi-canaux : WhatsApp / Telegram / Discord / app]
                 │
                 ▼
   [Passerelle de messagerie Mastra]
                 │
   [Cerveau cognitif CHRONICLE (cf. brain spec)]
   → Mémoire hiérarchique HMO/APEX (N0 épisodique → N1-2 résumés → N3 sémantique)
   → A-MEM (notes sémantiques + recoupement causal)
                 │
        ┌────────┴────────────────────┐
        ▼                             ▼
  [Imprévu / reprogrammation]   [Soutien motivationnel
   → ASCENT : report/             (signal drift AG07)
     micro-session]               → rappel / micro-obj (AG08)
   → préservation streak            / Hagah si stress]
        │                             │
        └────────┬────────────────────┘
                 ▼
   [Réponse cohérente multi-canal (identité unique)]
                 │
                 ▼
   [Sync cloud : chiffrement on-device + Differential Privacy]
```

---

## 2. Dépendances Techniques Strictes
* **Passerelle multi-canal** : connecteurs WhatsApp/Telegram/Discord + app native.
* **Cerveau cognitif** : HMO/APEX, A-MEM, DP — `scy_chronicle_agent_brain_spec.md`.
* **Agents partenaires** : AGENT-07 (drift), AGENT-08 (motivation), ASCENT (sessions).
* **Sécurité** : chiffrement AES on-device, Differential Privacy avant sync.
* **Zod** : `MessageSchema`, `ReprogramSchema`.

---

## 3. Fichiers et Tables Impactés
- **`backend_ts/src/ascent/agents/ag10_chronicle.ts`** : Step Mastra (orchestration compagnon).
- **`backend_ts/src/ascent/chronicle/messaging_gateway.ts`** : Passerelle multi-canal.
- **`backend_ts/src/ascent/chronicle/session_reprogrammer.ts`** : Reprogrammation souple des sessions.
- **Tables mémoire** : niveaux N0-N3 (cf. brain spec), `mfg_sessions` (reprogrammation).
