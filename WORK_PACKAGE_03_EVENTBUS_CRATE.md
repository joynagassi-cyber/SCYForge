Fin du WP03 précédent, continuation ici :

```rust
#[test]
fn dlq_retries_under_max_retries_then_quarantines() {
    let mut dlq = DeadLetterQueue::new(3);
    let ev = Event::new(EventType::TreeOpGrafted, "core", /* ... */);

    // 3 échecs → toujours dans la file de retry (max atteint)
    dlq.record_failure(ev.clone(), "timeout");
    dlq.record_failure(ev.clone(), "timeout");
    dlq.record_failure(ev.clone(), "timeout");

    let retriable = dlq.drain_retriable();
    assert!(retriable.is_empty()); // 3 tentatives = max atteint → reste en DLQ
    assert_eq!(dlq.failed.len(), 1); // toujours bloqué

    let ev2 = Event::new(EventType::TreeOpTested, "core", /* ... */);

    // 2 échecs → retryable
    dlq.record_failure(ev2.clone(), "timeout");
    dlq.record_failure(ev2.clone(), "timeout");

    let retriable2 = dlq.drain_retriable();
    assert_eq!(retriable2.len(), 1); // retryable car < 3
    assert_eq!(dlq.drain_all().len(), 1); // le premier bloque toujours
}
```

### 6.2 `tests/requires_reply_test.rs`

```rust
#[test]
fn requires_reply_single_then_expires() {
    let bus = InMemoryEventBus::new(30); // max 30 events in queue

    let (tx, rx) = std::sync::mpsc::channel();
    let handler = ReplyCollector::new(Box::new(move |e| {
        let _ = tx.send(e);
        SubscriberResult { accepted: true, error: None }
    }));

    let handle = bus.subscribe(EventType::TreeOpGrafted, handler);

    // Event requires_reply = true
    let event = Event {
        requires_reply: true,
        replied: false,
        // ...
    };
    bus.publish(event.clone()).await.unwrap();

    // Premiere publication → 1 reply attendu
    let reply = rx.recv().unwrap();
    assert_eq!(reply.event_id, event.id);

    // Deuxieme publication → pub bloquée par EIG
    let result = bus.publish(event.clone()).await;
    assert!(result.is_err()); // RequiresReplyExpired blocking rule
}
```

### 6.3 `tests/event_payload_serialization_test.rs`

```rust
#[test]
fn all_18_event_types_serialize_deserialize() {
    let events = vec![
        (EventType::TreeOpPlanted, TreeOpPlantedPayload { /* ... */ }),
        (EventType::TreeOpGrafted, TreeOpGraftedPayload { /* ... */ }),
        // ... tous les 18 types
        (EventType::SeedStatusChanged, SeedStatusChangedPayload { /* ... */ }),
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

- [ ] `src/lib.rs` — préambule + déclaration du crate
- [ ] `src/event.rs` — Event, EventType (18 variants), EventPayload (enum tag/content), types auxiliaires (OutputPressurePolicy, LoopId, LoopType, TriggerScope…)
- [ ] `src/bus.rs` — Trait EventBus, trait Subscriber, SubscriberResult, SubscriptionHandle
- [ ] `src/handler.rs` — PubSubHandler trait + note unsubscribe interdit
- [ ] `src/dlq.rs` — DeadLetterQueue + QueuedEvent + drain_retriable/drain_all
- [ ] `src/eig.rs` — EventValidationGate, ValidationResult, BlockingRule (3 variants), EIGPipeline
- [ ] `src/schemas.rs` — Tous les 18 structs de payload
- [ ] `Cargo.toml` du crate — déclaration interne vs scy-shared
- [ ] `cargo check -p scy-eventbus` — COMPILE
- [ ] Tests unitaires : DLQ retry, requires_reply expiry, all 18 types serialize
- [ ] Aucun terme métier cyber dans les noms de types/événements
- [ ] **NOTE: Demo contract binding** — `requires_reply` = true puis bloque la 2e publication via EIG
- [ ] **NOTE: Max 2 niveaux de contexte** — pas de HashMap Vec HashMap récursif

---

## 8. Ce que tu NE fais PAS dans ce work package

- ❌ Implémenter le subscriber EventBus pour chaque agent (VILLAGE_PUBLISHERS)
- ❌ Implémenter une impl Redis/NATS (MVP = in-memory only, Redis en v2)
- ❌ Créer des migrations SQL pour l"EventBus (la DLQ est in-memory MVP)
- ❌ Implémenter le schema scy_event_log dans Supabase (WP02 v003)
- ❌ Connecter l"EventBus à Mastra backend_ts (WP18+)
- ❌ Modifier les types Rust définis dans WP01

---

*Fin du WORK PACKAGE 03. Implémente UNIQUEMENT ce qui est dans ce fichier. Si tu as un doute, demande.*
