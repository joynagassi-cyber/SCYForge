# WORK PACKAGE 03 — EventBus Crate (scy-eventbus)

> **Statut** : À implémenter
> **Priorité** : 🔴 P0 — Fondation bloquante pour WP05 (adapter Postgres), WP06-WP14
> **Dépendances** : WP01 (DCID traits) doit exister
> **Références** : `MASTER_AGENT_PROMPT.md` (Règle #5 EventBus), `WORK_PACKAGE_01_DCID_TRAITS.md` (traits EventBus), `WORK_PACKAGE_05_POSTGRES_ADAPTER.md` (EventBus event persistence), `docs/SCYFORGE_SEQUENCE_DIAGRAMS.md` (flots d'événements)

---

## 1. Objectif

Implémenter le crate **`scy-eventbus`** : système de communication asynchrone entre les 18 agents ASCENT et les services transverses. Toute mutation d'état (TreeOp, Scenario, Mastery, Seed) passe par l'EventBus. Zéro appel direct inter-services.

**Livrable** : crate `scy-eventbus` qui compile (`cargo check -p scy-eventbus` passe), avec EventBus trait, 18 events typés, subscriber/pub-sub pattern, DLQ, et tests DLQ + requires_reply + sérialisation.

---

## 2. Contexte (lis ABSOLUMENT ceci avant de coder)

1. `WORK_PACKAGE_01_DCID_TRAITS.md` — EventBus trait + Subscriber trait + contraintes DCID
2. `WORK_PACKAGE_05_POSTGRES_ADAPTER.md` — EventBus event persistence (DLQ) + `scy_event_log`
3. `docs/SCYFORGE_SEQUENCE_DIAGRAMS.md` — flots d'événements complet (TreeOp, Scenario, Mastery, Seed)
4. `minddoc/s00_architecture_standards/scy_architectural_blueprint_master.md` — D-010 (Observer Pattern/EventBus)

---

## 3. Contraintes NON-NÉGOTIABLES

1. **Zéro terme métier cyber** dans les noms de types/événements. Les événements sont génériques (`TreeOpPlanted`, `ScenarioEvaluated`), pas `CyberAlertPublished`.
2. **18 événements typés** — chaque événement a un `EventType` enum + un payload struct. Pas de `HashMap<String, JsonValue>` générique.
3. **EventBus est un trait** — l'implémentation par défaut est `InMemoryEventBus` (MVP). L'implémentation Postgres `PostgresEventBus` (WP05) est séparée.
4. **Toute mutation publie un événement** — un `graft()` qui ne publie pas `TreeOpGrafted` est incorrect.
5. **DLQ obligatoire** — après `max_retries` échecs, l'événement est déplacé en DeadLetterQueue pour inspection manuelle.
6. **`requires_reply` gate** — si un événement a `requires_reply = true`, un second publish du même type bloque jusqu'à réception du reply (EIG — EventValidationGate).
7. **Pas de subscriber qui modifie l'état** — les subscribers sont en lecture seule. Toute mutation passe par un event → handler → mutation.
8. **Aucun appel inter-services** — ASCENT Agent-03 ne connaît pas ASCENT Agent-07. Ils communiquent uniquement via EventBus.
9. **Sérialisation JSON validée** — tous les payloads utilisent `serde` + `scy-shared` types. Pas de JSON non structuré.
10. **Max 2 niveaux de contexte** — pas de `HashMap<Vec<HashMap<...>>>` récursif dans les payloads.

---

## 4. Architecture cible

```
backend_rs/crates/scy-eventbus/src/
├── lib.rs                  # Préambule + exports du crate
├── event.rs                # Event, EventType (18 variants), EventPayload (enum)
├── bus.rs                  # Trait EventBus, trait Subscriber, SubscriberResult
├── handler.rs              # PubSubHandler trait + unsubscribe interdit
├── dlq.rs                  # DeadLetterQueue + QueuedEvent + drain_retriable
├── eig.rs                  # EventValidationGate, BlockingRule, EIGPipeline
├── schemas.rs              # 18 structs de payload (un par EventType)
└── tests/                  # Tests unitaires + intégration
    ├── dlq_test.rs
    ├── requires_reply_test.rs
    ├── event_payload_serialization_test.rs
    └── eig_pipeline_test.rs
```

### 4.1 Types génériques (définis dans `scy-shared`, consommés ici)

```rust
// Ces types sont définis dans WP01 (scy-shared/src/ports.rs et tree.rs)
// et consommés par scy-eventbus.

pub enum EventType {
    // TreeOp events
    TreeOpPlanted,
    TreeOpGrafted,
    TreeOpPruned,
    TreeOpTested,
    TreeOpMyelinated,
    // Scenario events
    ScenarioStarted,
    ScenarioReacted,
    ScenarioEvaluated,
    ScenarioCompleted,
    // Mastery events
    MasteryUpdated,
    MasteryThreshold,
    GapDetected,
    CertEarned,
    // Seed events
    SeedPollinated,
    SeedGerminated,
    SeedDormant,
    SeedValidated,
    SeedRejected,
}

pub struct Event {
    pub event_id: Uuid,
    pub event_type: EventType,
    pub payload: EventPayload,
    pub requires_reply: bool,
    pub replied: bool,
    pub owner_kind: OwnerKind,
    pub owner_id: Uuid,
    pub created_at: i64,
}

pub enum EventPayload {
    TreeOpPlanted(TreeOpPlantedPayload),
    TreeOpGrafted(TreeOpGraftedPayload),
    // ... 18 variants
}

// Chaque payload = struct dédiée (pas de généricité)
pub struct TreeOpPlantedPayload {
    pub tree_id: Uuid,
    pub roots: Vec<Uuid>,
    pub actor: String, // "system" | "agent_03" | "user"
}

pub struct TreeOpGraftedPayload {
    pub tree_id: Uuid,
    pub parent_id: Uuid,
    pub child_id: Uuid,
    pub actor: String,
}

// ... 16 autres payload structs
```

---

## 5. Livrable détaillé — File par File

### 5.1 `lib.rs` — Préambule

```rust
//! scy-eventbus — EventBus asynchrone pour SCY Forge.
//! Référence : D-010 (Observer Pattern / EventBus).
//! Règle d'or : ZERO appel direct inter-services. Toute communication passe par ce bus.
//! 18 événements typés + DLQ + EventValidationGate (EIG).

pub mod event;
pub mod bus;
pub mod handler;
pub mod dlq;
pub mod eig;
pub mod schemas;

pub use event::{Event, EventType, EventPayload};
pub use bus::{EventBus, InMemoryEventBus};
pub use handler::{Subscriber, SubscriberResult, PubSubHandler};
pub use dlq::{DeadLetterQueue, QueuedEvent};
pub use eig::{EventValidationGate, BlockingRule, EIGPipeline};
```

### 5.2 `event.rs` — Event + EventType (18 variants) + EventPayload

Définit l'`EventType` enum (18 variants), la struct `Event`, l'`EventPayload` enum (tag/content) et les types auxiliaires (`SubscriberResult`, `SubscriptionHandle`).

**Règle** : 18 variants EXACTEMENT. Pas de variante `Custom`. Chaque variant correspond à un événement du catalogue `SCYFORGE_SEQUENCE_DIAGRAMS.md` §Flots d'Événements.

### 5.3 `bus.rs` — EventBus trait + InMemoryEventBus impl

```rust
#[async_trait]
pub trait EventBus: Send + Sync {
    async fn publish(&self, event: Event) -> AppResult<()>;
    async fn subscribe(&self, event_type: EventType, handler: impl Subscriber + 'static) -> SubscriptionHandle;
    async fn unsubscribe(&self, handle: SubscriptionHandle) -> AppResult<()>;
}

pub struct InMemoryEventBus {
    subscribers: Arc<RwLock<HashMap<EventType, Vec<BoxedSubscriber>>>>,
    queue: Arc<RwLock<VecDeque<Event>>>,
    dlq: Arc<DeadLetterQueue>,
    eig: Arc<EIGPipeline>,
}
```

**Règles** :
- `publish()` vérifie d'abord l'EIG (bloque si `requires_reply` non satisfait).
- Chaque événement publié est dispatché à tous les subscribers de ce `EventType`.
- `subscribe()` retourne un `SubscriptionHandle` — **unsubscribe est interdit** (handler lives forever).
- `InMemoryEventBus` = implémentation MVP (en mémoire). `PostgresEventBus` = WP05.

### 5.4 `handler.rs` — Subscriber trait + PubSubHandler

```rust
#[async_trait]
pub trait Subscriber: Send + Sync {
    async fn handle(&self, event: Event) -> SubscriberResult;
}

pub struct SubscriberResult {
    pub accepted: bool,
    pub error: Option<String>,
}
```

**Règle** : un subscriber qui retourne `accepted: false` + `error: Some(...)` déclenche un retry (max 3 fois → DLQ).

### 5.5 `dlq.rs` — DeadLetterQueue

```rust
pub struct DeadLetterQueue {
    max_retries: usize,
    failed: Vec<QueuedEvent>,
}

pub struct QueuedEvent {
    pub event: Event,
    pub failures: Vec<String>,
    pub first_failed_at: i64,
}

impl DeadLetterQueue {
    pub fn new(max_retries: usize) -> Self;
    pub fn record_failure(&mut self, event: Event, reason: String);
    pub fn drain_retriable(&mut self) -> Vec<Event>; // retries < max
    pub fn drain_all(&mut self) -> Vec<QueuedEvent>; // tous (debug/inspection)
}
```

**Règle** : après `max_retries` échecs, l'événement reste en DLQ (bloqué) — pas de suppression automatique. L'inspection humaine est requise.

### 5.6 `eig.rs` — EventValidationGate

```rust
pub enum BlockingRule {
    RequiresReplyNotSatisfied, // requires_reply=true mais pas de reply reçu
    OwnerMismatch,             // owner_kind/owner_id ne correspond pas
    RateLimitExceeded,         // trop d'événements du même type en < X secondes
}

pub struct EventValidationGate {
    pending_replies: Arc<RwLock<HashMap<EventType, Event>>>,
    rate_limits: Arc<RwLock<HashMap<EventType, Vec<i64>>>>,
}

pub enum ValidationResult {
    Passed,
    Blocked(BlockingRule),
}
```

**3 BlockingRules** :
1. `RequiresReplyNotSatisfied` : si `requires_reply=true` et un event du même type est déjà pending → bloque la 2e publication.
2. `OwnerMismatch` : un event publié avec un `owner_kind`/`owner_id` qui ne correspond pas au contexte courant → bloque.
3. `RateLimitExceeded` : plus de 100 événements du même type en < 1 seconde → bloque (anti-spam).

### 5.7 `schemas.rs` — 18 payload structs

Chacune des 18 `EventType` a sa payload struct :

| EventType | Payload struct | Champs |
|---|---|---|
| `TreeOpPlanted` | `TreeOpPlantedPayload` | `tree_id`, `roots: Vec<Uuid>`, `actor` |
| `TreeOpGrafted` | `TreeOpGraftedPayload` | `tree_id`, `parent_id`, `child_id`, `actor` |
| `TreeOpPruned` | `TreeOpPrunedPayload` | `tree_id`, `removed_ids: Vec<Uuid>`, `actor` |
| `TreeOpTested` | `TreeOpTestedPayload` | `tree_id`, `learner_id`, `node_id`, `evidence` |
| `TreeOpMyelinated` | `TreeOpMyelinatedPayload` | `tree_id`, `learner_id`, `node_id` |
| `ScenarioStarted` | `ScenarioStartedPayload` | `scenario_id`, `learner_id`, `pack_id` |
| `ScenarioReacted` | `ScenarioReactedPayload` | `scenario_id`, `step_id`, `choice_id`, `timestamp` |
| `ScenarioEvaluated` | `ScenarioEvaluatedPayload` | `scenario_id`, `learner_id`, `score`, `nodes_evaluated` |
| `ScenarioCompleted` | `ScenarioCompletedPayload` | `scenario_id`, `learner_id`, `final_score`, `certificate` |
| `MasteryUpdated` | `MasteryUpdatedPayload` | `learner_id`, `tree_id`, `node_id`, `old_confidence`, `new_confidence` |
| `MasteryThreshold` | `MasteryThresholdPayload` | `learner_id`, `tree_id`, `node_id`, `smi_score` |
| `GapDetected` | `GapDetectedPayload` | `learner_id`, `tree_id`, `missing_prereqs: Vec<Uuid>` |
| `CertEarned` | `CertEarnedPayload` | `learner_id`, `role`, `coverage`, `envelope_cells` |
| `SeedPollinated` | `SeedPollinatedPayload` | `seed_id`, `source_a`, `source_b`, `context` |
| `SeedGerminated` | `SeedGerminatedPayload` | `seed_id`, `tree_id`, `parent_node_id`, `new_node_id` |
| `SeedDormant` | `SeedDormantPayload` | `seed_id`, `reason` |
| `SeedValidated` | `SeedValidatedPayload` | `seed_id`, `viability`, `fecundity`, `validated_by` |
| `SeedRejected` | `SeedRejectedPayload` | `seed_id`, `reason`, `failed_criteria` |

---

## 6. Tests (obligatoires)

### 6.1 DLQ retry logic

```rust
#[test]
fn dlq_retries_under_max_retries_then_quarantines() {
    let mut dlq = DeadLetterQueue::new(3);
    let ev = Event::new(EventType::TreeOpGrafted, /* ... */);

    dlq.record_failure(ev.clone(), "timeout");
    dlq.record_failure(ev.clone(), "timeout");
    dlq.record_failure(ev.clone(), "timeout");

    let retriable = dlq.drain_retriable();
    assert!(retriable.is_empty()); // 3 tentatives = max atteint → reste en DLQ
    assert_eq!(dlq.failed.len(), 1);
}
```

### 6.2 `requires_reply` gate (EIG)

```rust
#[test]
fn requires_reply_single_then_expires() {
    let bus = InMemoryEventBus::new(30);

    let (tx, rx) = std::sync::mpsc::channel();
    let handler = ReplyCollector::new(Box::new(move |e| {
        let _ = tx.send(e);
        SubscriberResult { accepted: true, error: None }
    }));

    let handle = bus.subscribe(EventType::TreeOpGrafted, handler);
    let event = Event { requires_reply: true, replied: false, /* ... */ };
    bus.publish(event.clone()).await.unwrap();

    let reply = rx.recv().unwrap();
    assert_eq!(reply.event_id, event.id);

    // Deuxième publication bloquée par EIG
    let result = bus.publish(event.clone()).await;
    assert!(result.is_err());
}
```

### 6.3 Sérialisation des 18 événements

```rust
#[test]
fn all_18_event_types_serialize_deserialize() {
    let events = vec![
        (EventType::TreeOpPlanted, TreeOpPlantedPayload { /* ... */ }),
        // ... tous les 18 types
        (EventType::SeedRejected, SeedRejectedPayload { /* ... */ }),
    ];

    for (event_type, payload) in events {
        let event = Event::new(*event_type, payload);
        let json = serde_json::to_string(&event).unwrap();
        let deserialized: Event = serde_json::from_str(&json).unwrap();
        assert_eq!(event.event_type, deserialized.event_type);
    }
}
```

---

## 7. Checklist de livraison

- [ ] `src/lib.rs` — préambule + déclaration du crate (7 modules)
- [ ] `src/event.rs` — Event, EventType (18 variants), EventPayload (enum tag/content)
- [ ] `src/bus.rs` — Trait EventBus + InMemoryEventBus impl
- [ ] `src/handler.rs` — Subscriber trait + PubSubHandler (unsubscribe interdit)
- [ ] `src/dlq.rs` — DeadLetterQueue + QueuedEvent + drain_retriable/drain_all
- [ ] `src/eig.rs` — EventValidationGate + 3 BlockingRules + EIGPipeline
- [ ] `src/schemas.rs` — 18 payload structs (une par EventType)
- [ ] `Cargo.toml` — déclaration dépendances (serde, async-trait, uuid, tokio)
- [ ] `cargo check -p scy-eventbus` — COMPILE
- [ ] Tests unitaires : DLQ retry, requires_reply expiry, 18 types serialize, EIG blocking
- [ ] Aucun terme métier cyber dans les noms de types/événements
- [ ] `requires_reply` = true → bloque la 2e publication via EIG
- [ ] Max 2 niveaux de contexte dans les payloads

---

## 8. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter le subscriber EventBus pour chaque agent (VILLAGE_PUBLISHERS — WP18+)
- ❌ Implémenter une impl Redis/NATS (MVP = in-memory only, Redis en v2)
- ❌ Créer des migrations SQL pour l'EventBus (la DLQ est in-memory MVP)
- ❌ Implémenter le schema `scy_event_log` dans Supabase (WP02 v003)
- ❌ Connecter l'EventBus à Mastra backend_ts (WP18+)
- ❌ Modifier les types Rust définis dans WP01

---

*Fin du WORK PACKAGE 03.*
*Implémente UNIQUEMENT ce qui est dans ce fichier. Si tu as un doute, demande.*
