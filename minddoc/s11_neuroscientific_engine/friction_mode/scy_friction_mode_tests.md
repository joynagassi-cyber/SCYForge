<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Moteur neuroscientifique DIFFÉRÉ. Backend interne seulement.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 🧪 SCY-FRICTION-MODE — TESTS
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

**ID** : S11_NEURO_FRICTION_MODE_TESTS · **Décisions** : D-OPT-015, D-OPT-049

- **TC1** : Session FRICTION → entrelacement 70% domaine cible / 30% connexes maîtres (déterministe).
- **TC2** : Barres de progression masquées pendant la session active.
- **TC3** : Gain de rétention mesuré (×2 vs mode fluide, APEX FSRS).
- **TC4** : Aucune randomisation arbitraire (ratio 70/30 déterministe).
