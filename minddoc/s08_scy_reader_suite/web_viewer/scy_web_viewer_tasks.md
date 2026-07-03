<!--
BEACHHEAD PIVOT v2.0 — DEFERRED
Reader Suite DIFFÉRÉE. Phase 2+.
Source de vérité pivot : docs/SCYFORGE_PIVOT_ARCHITECTURE.md
Date du pivot : 2026-07-01
-->

# 📋 SCY-WEB-VIEWER — TÂCHES (TASKS)
**ID** : S08_READER_WEB_VIEWER_TASKS

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

### Tâche WV.1 : Coder le rendu read-only + score confiance (20 min)
* **Fichier** : `frontend_react/src/reader/WebViewer.tsx`
* **Description** : Rendu read-only strict (pas de sélection/copie), score confiance T12 en en-tête.
* **Critère** : Read-only strict ; score T12 affiché.

### Tâche WV.2 : Coder export + transitions (20 min)
* **Fichier** : `frontend_react/src/reader/WebViewer.tsx`
* **Description** : Boutons export 9 formats + « Ouvrir Reader Suite » + « Analyser Book Orchestrator ».
* **Critère** : Export et transitions fonctionnels.
