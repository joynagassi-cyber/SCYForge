<!--
BEACHHEAD PIVOT v2.0 — IN_MVP
Standards architecturaux — ajouter section beachhead
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🔐 SCY-INFRASTRUCTURE-SÉCURITÉ — SPÉCIFICATION (SPEC)
**ID** : S00_INFRA_SEC_SPEC · **Phase** : MVP · **Réf** : PRD §7.12

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
Module **Infrastructure & Sécurité** : auth, RLS, rate limiting, HTTPS, secrets, validation, GDPR, plateformes.

## 2. Sécurité
- **Auth** : JWT (access 1h, refresh 30j httpOnly) + OAuth Google/GitHub
- **Rate Limiting** : 10 ingestions/h Free, 100/h Premium
- **RLS PostgreSQL** : isolation native multi-tenant par user_id
- **HTTPS/WSS** : TLS 1.3 + HSTS + CSP
- **keyring 2.0** : Desktop OS keychain AES-256
- **Input validation** : serde (Rust) + Zod (TypeScript)
- **SQL Injection** : parameterized queries uniquement
- **GDPR** : Export données, Delete Account cascade, Event Sourcing audit trail
- **AI Act EU** : `scy_ai_decisions` (traçabilité), droit à l'explication

## 3. Plateformes
- **Desktop** : Electron 33 + Sidecar Rust + SQLite WAL (offline-first)
- **Web** : React 18 SPA, Vercel CDN, ISR, OAuth social
- **Mobile** : PWA Phase 0-1 (0$ dev) → React Native Phase 2+ (>5K users)

## 4. Requirements (RFC 2119)
- **THEN** le système SHALL isoler les données par RLS PostgreSQL (user_id).
- **AND** le système SHALL exposer JWT + OAuth (Google/GitHub).
- **AND** le système SHALL appliquer le rate limiting par tier.
- **AND** le système SHALL respecter GDPR (export + delete + audit).

## 5. Tests
- TC1 : RLS isole user_id (cross-user inaccessible). | TC2 : JWT access 1h + refresh 30j. | TC3 : Rate limiting (10/h Free). | TC4 : GDPR export + delete cascade. | TC5 : Desktop offline-first (SQLite WAL).
