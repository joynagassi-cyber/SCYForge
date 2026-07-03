<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-FORGE-PROTOCOL — TESTS
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

**ID** : S11_NEURO_FORGE_PROTOCOL_TESTS · **Décision** : D-OPT-014

- **TC1** : Demande de contenu → challenge FORGE exigé avant tout affichage (pas d'affichage passif).
- **TC2** : Challenge cohérent avec le concept clé réel du nœud.
- **TC3** : 2 échecs consécutifs sur nœud difficile → aide ELI5 (D-OPT-024).
- **TC4** : L'utilisateur accède toujours au contenu (réussite OU fallback, pas de blocage).
- **TC5** : Gain de rétention mesuré (+20% à +40% vs passif, APEX FSRS).
