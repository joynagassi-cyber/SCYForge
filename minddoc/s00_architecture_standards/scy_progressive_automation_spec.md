<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🎛️ SCY-PROGRESSIVE-AUTOMATION — SPÉCIFICATION TECHNIQUE D'IMPLÉMENTATION
**ID Spécification** : S00_PROGRESSIVE_AUTOMATION_SPEC  
**Date** : 2026-06-26  
**Statut** : 🟢 SPÉCIFICATION TECHNIQUE IMMUABLE ET VALIDÉE  
**Format d'Écriture** : SDD (Gherkin GIVEN-WHEN-THEN-AND) + Norme RFC 2119  

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

> **Règle d'or** : Le cœur SCYForge ne contient **aucun terme métier cyber** en dur.
> Tout ce qui est spécifique à la cybersécurité vit dans `packs/cyber/`.
> Si tu grep "MITRE", "SOC", "Sigma", "CVE" dans le cœur → **violation du contrat**.

---

## 1. Purpose

Le système de **Progressive Automation** permet à l'utilisateur de choisir son niveau d'implication dans SCY Forge, de manière **globale** (toute la plateforme) et **granulaire** (par domaine/feature). Trois niveaux coexistent : **Agentique** (l'agent décide tout), **Hybride** (l'agent propose, l'utilisateur ajuste — défaut), et **Manuel** (l'utilisateur contrôle tout). Chaque feature automatisée possède **toujours** un chemin manuel équivalent. L'agent n'impose jamais une décision sans possibilité d'override.

---

## 2. Data Model — Schéma BDD

### 2.1 Table : `scy_user_automation_prefs`

```sql
CREATE TABLE scy_user_automation_prefs (
    user_id UUID PRIMARY KEY REFERENCES scy_users(id),

    -- Niveau global d'autonomie
    global_level TEXT NOT NULL DEFAULT 'hybrid'
        CHECK (global_level IN ('agentic', 'hybrid', 'manual')),

    -- Niveau granulaire par domaine (JSONB)
    -- null = hérite du global_level
    domain_overrides JSONB DEFAULT '{}',

    -- Détection automatique (comportement observé)
    auto_detected_level TEXT,
    auto_detection_confidence REAL DEFAULT 0.0,
    suggestions_dismissed_count INTEGER DEFAULT 0,
    overrides_count INTEGER DEFAULT 0,

    -- Timestamps
    updated_at INTEGER NOT NULL,
    created_at INTEGER NOT NULL
);
```

### 2.2 Format du `domain_overrides` (JSONB)

```json
{
  "ingestion": "agentic",
  "card_creation": "manual",
  "cosmos_mode": "hybrid",
  "session_timing": "agentic",
  "routing": "hybrid",
  "imprint": "hybrid",
  "arena": "manual",
  "proof_of_skill": "hybrid"
}
```

Si une clé est absente → hérite de `global_level`.

### 2.3 Table : `scy_agent_proposals` (journal des propositions agentiques)

```sql
CREATE TABLE scy_agent_proposals (
    id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    user_id UUID NOT NULL REFERENCES scy_users(id),
    agent_name TEXT NOT NULL,              -- 'agent-03', 'chronicle', etc.
    feature_domain TEXT NOT NULL,           -- 'card_creation', 'cosmos_mode', etc.
    proposal_type TEXT NOT NULL,            -- 'auto_dag', 'auto_mode_cosmos', 'auto_session', etc.
    proposal_payload JSONB NOT NULL,        -- les données de la proposition
    user_action TEXT,                       -- 'accepted'|'rejected'|'modified'|'ignored'|null (pending)
    user_modifications JSONB,               -- si 'modified', ce que l'utilisateur a changé
    proposed_at INTEGER NOT NULL,
    resolved_at INTEGER
);

CREATE index idx_agent_proposals_user ON scy_agent_proposals(user_id, feature_domain, proposed_at DESC);
```

---

## 3. Data Model — Types Rust (Domain Layer)

```rust
// backend_rs/src/domain/automation.rs

use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// Niveau d'autonomie agentique
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum AutomationLevel {
    /// L'agent décide tout, l'utilisateur valide simplement
    Agentic,
    /// L'agent propose, l'utilisateur ajuste (DÉFAUT)
    Hybrid,
    /// L'utilisateur contrôle tout, l'agent aide sur demande seulement
    Manual,
}

impl Default for AutomationLevel {
    fn default() -> Self {
        AutomationLevel::Hybrid
    }
}

/// Domaines de features automatisables
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum FeatureDomain {
    Ingestion,        // Recherche et ingestion des sources
    CardCreation,     // Génération de cartes APEX
    CosmosMode,       // Sélection du mode de visualisation
    SessionTiming,    // Quand proposer les sessions de révision
    Routing,          // Routage ASCENT (fast-track/normal/remédiation)
    Imprint,          // Déclenchement IMPRINT
    Arena,            // Déclenchement ARENA
    ProofOfSkill,     // Déclenchement certification
}

/// Préférences d'automatisation de l'utilisateur
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct UserAutomationPrefs {
    pub user_id: Uuid,
    pub global_level: AutomationLevel,
    pub domain_overrides: HashMap<FeatureDomain, AutomationLevel>,
    pub auto_detected_level: Option<AutomationLevel>,
    pub auto_detection_confidence: f32,
    pub suggestions_dismissed_count: u32,
    pub overrides_count: u32,
}

impl UserAutomationPrefs {
    /// Résout le niveau effectif pour un domaine donné
    /// Si le domaine a un override → utilise l'override
    /// Sinon → hérite du global_level
    pub fn effective_level(&self, domain: FeatureDomain) -> AutomationLevel {
        self.domain_overrides
            .get(&domain)
            .copied()
            .unwrap_or(self.global_level)
    }

    /// L'agent peut-il agir automatiquement (sans demander) ?
    pub fn can_agent_auto_act(&self, domain: FeatureDomain) -> bool {
        match self.effective_level(domain) {
            AutomationLevel::Agentic => true,
            AutomationLevel::Hybrid => false,  // doit proposer d'abord
            AutomationLevel::Manual => false,   // ne propose même pas (sauf demande)
        }
    }

    /// L'agent doit-il proposer (mais attendre la validation) ?
    pub fn should_agent_propose(&self, domain: FeatureDomain) -> bool {
        match self.effective_level(domain) {
            AutomationLevel::Agentic => false,  // agit sans proposer
            AutomationLevel::Hybrid => true,    // propose et attend
            AutomationLevel::Manual => false,   // n'propose pas (sauf demande explicite)
        }
    }

    /// Le chemin manuel doit-il être affiché ?
    pub fn show_manual_controls(&self, domain: FeatureDomain) -> bool {
        match self.effective_level(domain) {
            AutomationLevel::Agentic => true,   // toujours disponible (optionnel)
            AutomationLevel::Hybrid => true,    // toujours visible
            AutomationLevel::Manual => true,    // c'est le mode principal
        }
        // → TOUJOURS TRUE : le manuel est JAMAIS caché
    }
}
```

---

## 4. Le Pattern `AgentProposal` (comment un agent propose)

Chaque action automatisée passe par le **même pattern** quel que soit le niveau :

```rust
// backend_rs/src/domain/automation.rs

/// Une proposition d'action agentique
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AgentProposal {
    pub id: Uuid,
    pub agent_name: String,
    pub domain: FeatureDomain,
    pub proposal_type: String,
    pub payload: serde_json::Value,
    pub status: ProposalStatus,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum ProposalStatus {
    Pending,     // En attente de validation utilisateur
    Accepted,    // L'utilisateur a accepté tel quel
    Rejected,    // L'utilisateur a refusé
    Modified,    // L'utilisateur a accepté mais modifié
    AutoApplied, // Appliqué automatiquement (niveau Agentic)
    Expired,     // Expiré (timeout)
}

/// Le moteur de Progressive Automation
pub struct AutomationEngine {
    prefs_repo: Arc<dyn AutomationPrefsRepository>,
    proposal_repo: Arc<dyn AgentProposalRepository>,
}

impl AutomationEngine {
    /// Un agent veut exécuter une action. Le moteur décide comment.
    pub async fn request_action(
        &self,
        user_id: Uuid,
        agent_name: &str,
        domain: FeatureDomain,
        action_type: &str,
        payload: serde_json::Value,
    ) -> ActionResult {
        let prefs = self.prefs_repo.get(user_id).await?;
        let level = prefs.effective_level(domain);

        match level {
            // AGENTIC : exécuter directement, informer l'utilisateur
            AutomationLevel::Agentic => {
                self.execute_and_notify(
                    user_id, agent_name, domain, action_type, payload,
                ).await
            }

            // HYBRID : créer une proposition, attendre la validation
            AutomationLevel::Hybrid => {
                let proposal = self.create_proposal(
                    user_id, agent_name, domain, action_type, payload,
                ).await?;
                ActionResult::AwaitingUserValidation(proposal)
            }

            // MANUAL : ne rien faire automatiquement
            // L'utilisateur doit déclencher l'action manuellement
            AutomationLevel::Manual => {
                ActionResult::Skipped(
                    "Manual mode : action available via manual controls".into()
                )
            }
        }
    }

    /// L'utilisateur répond à une proposition
    pub async fn resolve_proposal(
        &self,
        user_id: Uuid,
        proposal_id: Uuid,
        action: UserResponse,
        modifications: Option<serde_json::Value>,
    ) -> Result<(), AutomationError> {
        let mut proposal = self.proposal_repo.get(proposal_id).await?;

        match action {
            UserResponse::Accept => {
                proposal.status = ProposalStatus::Accepted;
                self.proposal_repo.update(proposal).await?;
                // Exécuter l'action avec le payload original
            }
            UserResponse::Reject => {
                proposal.status = ProposalStatus::Rejected;
                self.proposal_repo.update(proposal).await?;
                // L'agent s'adapte (Charte Humilité : "Pas de souci.")
                // Incrémenter overrides_count pour détection automatique
                self.increment_override(user_id).await?;
            }
            UserResponse::Modify => {
                proposal.status = ProposalStatus::Modified;
                proposal.user_modifications = modifications;
                self.proposal_repo.update(proposal).await?;
                // Exécuter l'action avec les modifications de l'utilisateur
                self.increment_override(user_id).await?;
            }
        }
        Ok(())
    }

    /// Détection automatique du niveau préféré (après ~20 interactions)
    pub async fn auto_detect_level(&self, user_id: Uuid) -> Option<AutomationLevel> {
        let prefs = self.prefs_repo.get(user_id).await.ok()?;

        // Besoin d'au moins 20 interactions pour détecter
        let total = prefs.suggestions_dismissed_count + prefs.overrides_count;
        if total < 20 {
            return None;
        }

        let acceptance_rate = 1.0 - (prefs.overrides_count as f32 / total as f32);

        if acceptance_rate > 0.85 {
            Some(AutomationLevel::Agentic)  // Accepte presque tout
        } else if acceptance_rate < 0.30 {
            Some(AutomationLevel::Manual)   // Override presque tout
        } else {
            Some(AutomationLevel::Hybrid)   // Comportement mixte
        }
    }
}

#[derive(Debug)]
pub enum ActionResult {
    Executed,                          // Action exécutée (Agentic)
    AwaitingUserValidation(AgentProposal), // Proposition en attente (Hybrid)
    Skipped(String),                   // Ignoré (Manual)
}

#[derive(Debug, Clone)]
pub enum UserResponse {
    Accept,
    Reject,
    Modify,
}
```

---

## 5. API REST Endpoints

### 5.1 Préférences

```
GET    /api/automation/prefs                    → récupère les préférences
PUT    /api/automation/prefs                    → met à jour global_level
PUT    /api/automation/prefs/domain             → met à jour un override de domaine
DELETE /api/automation/prefs/domain/:domain     → supprime l'override (hérite du global)
```

### 5.2 Propositions

```
GET    /api/automation/proposals                → liste les propositions en attente
POST   /api/automation/proposals/:id/accept     → accepter une proposition
POST   /api/automation/proposals/:id/reject     → refuser une proposition
POST   /api/automation/proposals/:id/modify     → accepter avec modifications
```

### 5.3 Détection automatique

```
GET    /api/automation/detection                → niveau détecté + suggestion
POST   /api/automation/detection/apply          → appliquer la suggestion détectée
POST   /api/automation/detection/dismiss        → ignorer la suggestion
```

---

## 6. Frontend — Composant React `AutomationSettings`

```typescript
// frontend_react/src/settings/AutomationSettings.tsx

import React from 'react';

const FEATURE_DOMAINS = [
  { key: 'ingestion',      label: 'Ingestion des sources',     icon: '📥' },
  { key: 'card_creation',  label: 'Création de cartes APEX',   icon: '🃏' },
  { key: 'cosmos_mode',    label: 'Mode COSMOS',               icon: '🌌' },
  { key: 'session_timing', label: 'Timing des sessions',        icon: '⏰' },
  { key: 'routing',        label: 'Routage ASCENT',            icon: '🔀' },
  { key: 'imprint',        label: 'IMPRINT',                   icon: '✍️' },
  { key: 'arena',          label: 'ARENA',                     icon: '⚔️' },
  { key: 'proof_of_skill', label: 'Certification',             icon: '🏆' },
] as const;

const LEVELS = [
  { value: 'agentic', label: '🤖 Agentique', desc: 'L\'agent décide tout' },
  { value: 'hybrid',  label: '🔀 Hybride',   desc: 'L\'agent propose, j\'ajuste' },
  { value: 'manual',  label: '🎛️ Manuel',    desc: 'Je contrôle tout' },
] as const;

export const AutomationSettings: React.FC = () => {
  const [globalLevel, setGlobalLevel] = useState('hybrid');
  const [overrides, setOverrides] = useState<Record<string, string>>({});
  const [detection, setDetection] = useState<DetectionResult | null>(null);

  const effectiveLevel = (domain: string) => overrides[domain] ?? globalLevel;

  return (
    <div className="space-y-6">
      {/* Niveau global */}
      <Card>
        <h3>Niveau d'autonomie global</h3>
        <RadioGroup value={globalLevel} onChange={setGlobalLevel}>
          {LEVELS.map(l => (
            <RadioGroup.Option key={l.value} value={l.value}>
              {l.label} — <span className="text-gray-500">{l.desc}</span>
            </RadioGroup.Option>
          ))}
        </RadioGroup>
      </Card>

      {/* Détection automatique (si disponible) */}
      {detection && (
        <Card>
          <p>
            D'après ton usage, tu sembles préférer le mode{' '}
            <strong>{detection.suggested}</strong>
            ({detection.confidence}% de confiance).
          </p>
          <Button onClick={() => applyDetection()}>Appliquer</Button>
          <Button variant="ghost" onClick={() => dismissDetection()}>Non merci</Button>
        </Card>
      )}

      {/* Granulaire par domaine */}
      <Card>
        <h3>Paramétrage par domaine</h3>
        <table>
          <thead>
            <tr>
              <th>Feature</th>
              <th>Niveau</th>
            </tr>
          </thead>
          <tbody>
            {FEATURE_DOMAINS.map(domain => (
              <tr key={domain.key}>
                <td>{domain.icon} {domain.label}</td>
                <td>
                  <Select
                    value={effectiveLevel(domain.key)}
                    onChange={(v) => setOverrides({
                      ...overrides,
                      [domain.key]: v,
                    })}
                    options={LEVELS}
                  />
                  {overrides[domain.key] === undefined && (
                    <span className="text-gray-500 text-xs">(hérite du global)</span>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </Card>
    </div>
  );
};
```

---

## 7. Frontend — Le composant `AgentProposalBanner`

Quand un agent fait une proposition (mode Hybride), un **banner non-intrusif** apparaît en haut de l'écran :

```typescript
// frontend_react/src/components/AgentProposalBanner.tsx

export const AgentProposalBanner: React.FC<{ proposal: AgentProposal }> = ({ proposal }) => {
  return (
    <div className="agent-proposal-banner">
      <div className="flex items-center gap-3">
        <AgentAvatar agent={proposal.agent_name} />
        <div>
          <p className="text-sm">
            <AgentName agent={proposal.agent_name} /> propose :{' '}
            <strong>{proposal.description}</strong>
          </p>
          <p className="text-xs text-gray-500">
            {proposal.reasoning}  {/* Pourquoi l'agent propose ça */}
          </p>
        </div>
      </div>
      <div className="flex gap-2">
        <Button size="sm" onClick={() => acceptProposal(proposal.id)}>
          ✅ Accepter
        </Button>
        <Button size="sm" variant="outline" onClick={() => modifyProposal(proposal.id)}>
          ✏️ Modifier
        </Button>
        <Button size="sm" variant="ghost" onClick={() => rejectProposal(proposal.id)}>
          ❌ Non merci
        </Button>
      </div>
    </div>
  );
};
```

**Règles d'affichage** :
- Max **1 proposition** affichée à la fois (pas de pile).
- Si l'utilisateur ignore la proposition > 5 min → elle reste mais devient discrète (opacity réduite).
- Si l'utilisateur refuse → l'agent dit *"Pas de souci."* (Charte Humilité) et s'adapte.

---

## 8. Frontend — Comment les contrôles manuels coexistent

Pour chaque feature, le contrôle manuel est **toujours visible/accessible**, quel que soit le niveau :

### COSMOS (sélection de mode)
```typescript
// Le sélecteur de mode est TOUJOURS visible en haut de COSMOS
// Même en mode Agentique, l'utilisateur peut cliquer manuellement

<div className="cosmos-toolbar">
  {/* Sélecteur manuel toujours visible */}
  <CosmosModeSelector
    modes={[M00, M02, M03, M04, M05, M06, M07, ...M25]}
    current={currentMode}
    onChange={(mode) => setMode(mode)}  // override manuel
  />

  {/* Badge si l'agent a sélectionné ce mode automatiquement */}
  {modeSelectedByAgent && (
    <Badge variant="info">
      🤖 Sélectionné par {agentName}
    </Badge>
  )}
</div>
```

### APEX (création de cartes)
```typescript
// Le bouton "Créer carte" est TOUJOURS visible dans l'interface APEX
<div className="apex-toolbar">
  <Button onClick={() => openManualCardCreator()}>
    ➕ Créer une carte
  </Button>

  {/* Badge si les cartes sont auto-générées */}
  {cardsAutoGenerated && (
    <Badge>🤖 12 cartes générées par NEURON-CHAINS</Badge>
  )}
</div>
```

### Sessions (lancement)
```typescript
// Le bouton "Réviser maintenant" est TOUJOURS visible
<div className="session-bar">
  <Button variant="primary" onClick={() => startSession()}>
    ▶ Réviser maintenant ({dueCount} cartes dues)
  </Button>

  {/* Si CHRONICLE a proposé une session */}
  {chronicleProposal && (
    <Badge>🤖 CHRONICLE suggère : {chronicleProposal.time}</Badge>
  )}
</div>
```

---

## 9. EventBus — Événements de Progressive Automation

```rust
// Événements liés au système d'automatisation
pub enum AutomationEvent {
    // Une préférence a changé
    AutomationLevelChanged {
        user_id: Uuid,
        domain: FeatureDomain,
        old_level: AutomationLevel,
        new_level: AutomationLevel,
    },

    // Une proposition a été créée (mode Hybride)
    ProposalCreated {
        user_id: Uuid,
        proposal_id: Uuid,
        agent_name: String,
        domain: FeatureDomain,
    },

    // Une proposition a été résolue
    ProposalResolved {
        user_id: Uuid,
        proposal_id: Uuid,
        response: UserResponse,
    },

    // Le niveau préféré a été détecté automatiquement
    AutoLevelDetected {
        user_id: Uuid,
        detected_level: AutomationLevel,
        confidence: f32,
    },
}
```

Les agents **écoutent** ces événements :
- `ProposalResolved(Rejected)` → l'agent **incrémente** son compteur d'override et s'adapte.
- `AutomationLevelChanged(Manual)` → l'agent **cesse** de proposer pour ce domaine.
- `AutomationLevelChanged(Agentic)` → l'agent **commence** à agir sans demander.

---

## 10. Requirements (RFC 2119)

### Niveau d'automatisation
- **THEN** le système SHALL stocker un niveau global (`agentic`/`hybrid`/`manual`) par utilisateur.
- **AND** le système SHALL permettre des overrides granulaires par domaine (8 domaines).
- **AND** si un domaine n'a pas d'override → il SHALL hériter du niveau global.

### Comportement par niveau
- **Agentic** : le système SHALL exécuter l'action automatiquement ET notifier l'utilisateur.
- **Hybrid** : le système SHALL créer une proposition ET attendre la validation (accept/reject/modify).
- **Manual** : le système SHALL NE PAS proposer automatiquement. L'utilisateur accède à l'action via les contrôles manuels.

### Contrôles manuels
- **THEN** pour CHAQUE feature automatisée, un contrôle manuel équivalent SHALL être **toujours visible et fonctionnel**, quel que soit le niveau.
- **AND** le contrôle manuel SHALL NE JAMAIS être caché ou désactivé.

### Override utilisateur
- **THEN** l'utilisateur SHALL pouvoir override n'importe quelle décision agentique à tout moment.
- **AND** si l'utilisateur rejette une proposition → l'agent SHALL s'adapter sans insister (Charte Humilité : *"Pas de souci."*).
- **AND** le système SHALL tracker les overrides pour la détection automatique.

### Détection automatique
- **THEN** après ≥ 20 interactions, le système SHALL calculer un niveau préféré (acceptance_rate).
- **AND** si acceptance_rate > 85% → suggérer Agentic. Si < 30% → suggérer Manual.
- **AND** la suggestion SHALL être non-intrusive (1 notification, optionnelle).

### Propositions (mode Hybride)
- **THEN** le système SHALL afficher max 1 proposition à la fois.
- **AND** chaque proposition SHALL avoir 3 actions : Accepter / Modifier / Refuser.
- **AND** chaque proposition SHALL expliquer POURQUOI l'agent la fait (reasoning).

---

## 11. Test cases & Validation

- **TC1 (Agentic)** : Niveau Agentic → Agent-03 génère le DAG automatiquement → utilisateur notifié, DAG créé sans validation.
- **TC2 (Hybrid)** : Niveau Hybrid → Agent-03 propose le DAG → banner avec Accepter/Modifier/Refuser → DAG créé après acceptation.
- **TC3 (Manual)** : Niveau Manual → Agent-03 ne propose rien → utilisateur ouvre l'éditeur DAG manuel.
- **TC4 (Override)** : Mode Agentic → agent sélectionne COSMOS M14 → utilisateur clique manuellement sur M02 → vue bascule vers M02 (override).
- **TC5 (Granulaire)** : Ingestion=Agentic + CardCreation=Manual → Agent-02 ingère automatiquement MAIS cartes créées manuellement.
- **TC6 (Détection)** : 20 interactions avec 90% d'acceptation → suggestion "Passer en Agentique" affichée.
- **TC7 (Contrôles manuels)** : En mode Agentic, le sélecteur COSMOS + bouton "Créer carte" + "Réviser" sont TOUJOURS visibles.
- **TC8 (Rejet)** : Utilisateur refuse proposition → *"Pas de souci."* → compteur override incrémenté → agent s'adapte.
- **TC9 (Modify)** : Utilisateur modifie une proposition → action exécutée avec les modifications → compteur override incrémenté.
- **TC10 (EventBus)** : AutomationLevelChanged → tous les agents écoutent et ajustent leur comportement.
