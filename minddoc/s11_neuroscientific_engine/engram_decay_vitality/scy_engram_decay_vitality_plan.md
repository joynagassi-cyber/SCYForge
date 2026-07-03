<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🛠️ SCY-ENGRAM-DECAY-VITALITY — PLAN D'IMPLÉMENTATION TECHNIQUE (PLAN)
**ID Spécification** : S11_ENGRAM_DECAY_VITALITY_PLAN  
**Statut** : 🟢 PLAN D'IMPLÉMENTATION IMMUABLE ET VALIDÉ  

---

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

## 1. Architecture du Flux de Données

### Cycle de Déclin et Dormance Froide (Tâche Cron Quotidienne)
```
[Base de données PostgreSQL] ──► [Calculateur Rust Axum Engine]
                                           │
                                           ▼ (Application de l'Équation Sigmoïdale)
                                     [Calcul Vitalité V_n(t)]
                                           │
                        ┌──────────────────┴──────────────────┐
                        ▼ (V_n >= 20.0)                       ▼ (V_n < 20.0)
                [Maintien Actif]                       [Déclenchement Dormance]
                        │                                     │
                        ▼                                     ▼
                [Mise à jour Vitalité]                 [Déplacement vers scy_engram_vault]
                                                       [Purger de COSMOS et RAG BRAIN]
```

### Processus de Résurrection Active (Workflow Utilisateur)
```
[Sélection d'un nœud dormant] ──► [Extraction des 3 mots-clés d'indices] ──► [Affichage UI]
                                                                                   │
                                                                                   ▼
                                                                     [Saisie texte de l'Élève]
                                                                                   │
                                                                                   ▼
                                                                     [Moteur Rust Similarity]
                                                                                   │
                                                   ┌───────────────────────────────┴───────────────────────────────┐
                                                   ▼ (Similarité >= 70%)                                           ▼ (Similarité < 70%)
                                        [Restauration dans le graphe]                                     [Maintien Dormance]
                                        [Initialisation Vitalité = 50.0]                                  [Incrémenter tentatives]
                                        [Purger de scy_engram_vault]                                      [Feedback Socratique d'Indice]
```

---

## 2. Dépendances Techniques Strictes
* **Environnement Serveur** :
  - **Moteur Rust Core (Axum)** : Calcul haute vitesse de similarité cosinus via embeddings locaux générés par ONNX/Candle (modèle local `all-MiniLM-L6-v2` ultra-rapide).
  - **Mastra TS (Cron Engine)** : Planification et orchestration des déclenchements réguliers à coût nul.
* **Base de Données** :
  - **PostgreSQL** : Triggers de sécurité et contraintes d'intégrité pour éviter toute perte de données lors du transfert vers le coffre.

---

## 3. Fichiers et Tables Impactés
- **`backend_rust/src/neuroscientific/engram_decay.rs`** : Implémentation mathématique de l'équation de déclin et du calcul de similarité.
- **`backend_ts/src/normal_pipeline/workflows/engramCron.ts`** : Workflow d'arrière-plan gérant l'évaluation journalière.
- **`scy_synaptic_vitality`** : Table de stockage active du score de vitalité et des composantes cognitives.
- **`scy_engram_vault`** : Table d'archivage froid sécurisée contenant le payload JSON des nœuds et les mots-clés d'indices.
- **`scy_forge_attempts`** : Journalisation et validation des tentatives de résurrection sémantique.
