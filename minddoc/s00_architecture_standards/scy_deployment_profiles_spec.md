# SCYFORGE — Deployment Profiles Specification

> **Document ID** : S00_DEPLOYMENT_PROFILES  
> **Date** : 2026-07-01  
> **Statut** : 🟡 EN REVISION  
> **Référence** : D-023, D-024, `SCYFORGE_FEATURE_REPORT.md §12.3.1`, `SCYFORGE_PIVOT_ARCHITECTURE.md §9`

---

## 1. Principe Fondateur

> **Un seul Cyber Pack, deux jeux de valeurs de providers.** La structure du Semantic Tree (tronc SOC L1 + sous-arbre ATT&CK) est **identique** pour les deux profils. Ce qui change = les **valeurs injectées dans 4 providers** + les **bornes de l'Autonomy Envelope**. On peut retirer le profil régulé sans casser le pack : c'est le test « pack dans le pack ».

---

## 2. Les 2 Profils de Déploiement

| Axe | **MSSP/MDR** | **SOC interne régulé** |
|---|---|---|
| **Moteur d'achat** | Marge / capacité à former des L1 en volume | Conformité (NIS2/DORA) + rétention/risque |
| **Corpus d'ancrage** | Playbooks standardisés multi-clients | SOP internes + contraintes sectorielles (finance/santé) |
| **Autonomy Envelope** | Large, orienté débit de tickets | Stricte, orientée séparation des données / audit |
| **ProofRubric** | Vitesse + volume + exactitude | Traçabilité + conformité + exactitude |
| **Séquencement** | Segment amorce (douleur onboarding maximale, cycle de vente court) | Segment d'expansion (ticket plus gros, cycle plus long) |
| **ACV** | ~5 000 $/an | 15 000–50 000 $/an |
| **TAM (FR)** | ~50 SOCs tech | ~10 000 entreprises non-tech |

---

## 3. 4 Providers Profile-Aware

Les 4 providers suivants acceptent un `profile_ref ∈ {mssp_mdr, regulated_internal}` et renvoient des valeurs différentes. Le contrat du provider ne change pas — seules les valeurs varient.

| Provider | Ce qui change par profil | Impact |
|---|---|---|
| **ProofRubricProvider** | Vecteur de poids `w_accuracy / w_speed / w_volume / w_justification / w_audit` | Régulé monte `w_justification` et `w_audit` (bloquant) ; MSSP monte `w_speed` et `w_volume` |
| **ValidationGuardProvider** | Règles de garde-fous additionnelles | Régulé ajoute : séparation détection/réponse stricte, résidence données, traçabilité IA, conservation 5–7 ans + crypto-shredding |
| **CorpusProvider** | Mix privé/sectoriel + contexte réglementaire | Régulé injecte NIS2/DORA/RGPD comme faits d'ancrage ; MSSP minimale |
| **RoleTaxonomyProvider** | Périmètre de l'Envelope (`ceilingMode` par classe d'alerte) | Régulé : plus strict ; MSSP : plus large |

---

## 4. Profil MSSP/MDR — Valeurs par Défaut

### 4.1 ProofRubric — Vecteur de poids

| Dimension | Poids | Gate |
|---|---|---|
| Exactitude verdict (FP/TP/escalade) | **élevé** | ≥ 90% |
| Vitesse (time-to-triage) | **fort** | < 5 min MTTT, 20–35 alertes/quart |
| Volume soutenable | **fort** | < 50 alertes actionnables/jour/analyste |
| Qualité justification / dossier | **modéré** | motif d'escalade présent |
| Complétude audit (log signé) | optionnel | non-gaté |

### 4.2 ValidationGuard — Règles

| Garde-fou | MSSP/MDR |
|---|---|
| Faits ATT&CK non négociables | ✅ |
| Pas de conseil offensif hors scope | ✅ |
| Séparation détection / réponse | recommandée |
| Résidence / traitement données | tolérance multi-tenant |
| Traçabilité de l'action IA | log léger |
| Rétention / droit à l'oubli | politique standard |

### 4.3 Autonomy Envelope — Bornes

| Classe d'alerte / risque | MSSP/MDR |
|---|---|
| FP évident / bruit connu | **auto-close autonome** |
| TP faible sévérité, playbook clair | **remédiation autonome** |
| TP moyenne sévérité | **escalade autonome** |
| Haute sévérité / incident majeur | escalade + notification interne |
| Donnée réglementée / hors résidence | triage autorisé |

---

## 5. Profil SOC interne régulé — Valeurs par Défaut

### 5.1 ProofRubric — Vecteur de poids

| Dimension | Poids | Gate |
|---|---|---|
| Exactitude verdict (FP/TP/escalade) | **élevé** | ≥ 95% (coût d'une erreur = notification réglementaire fausse) |
| Vitesse (time-to-triage) | **modéré** | time-to-classify < 2 h (fenêtre réglementaire) |
| Volume soutenable | non-gaté | pas de contrainte de volume |
| Qualité justification / dossier | **très élevé** | arbre de preuve « pourquoi ce verdict » + chaîne de conservation intacte |
| Complétude audit (log signé) | **obligatoire, gate bloquant** | pas de log signé ⇒ pas de certification |

### 5.2 ValidationGuard — Règles

| Garde-fou | SOC interne régulé |
|---|---|
| Faits ATT&CK non négociables | ✅ |
| Pas de conseil offensif hors scope | ✅ |
| Séparation détection / réponse | **stricte, imposée** (séparation des rôles auditée) |
| Résidence / traitement données | **où la donnée est traitée ET accédée** (refus si contexte sort du périmètre) |
| Traçabilité de l'action IA | **chemin d'oversight humain + log du raisonnement autonome obligatoire** |
| Rétention / droit à l'oubli | **conservation 5–7 ans + crypto-shredding** (destruction de clé, audit trail immuable préservé) |

### 5.3 Autonomy Envelope — Bornes

| Classe d'alerte / risque | SOC interne régulé |
|---|---|
| FP évident / bruit connu | auto-close autonome **avec log signé** |
| TP faible sévérité, playbook clair | remédiation **assistée** (validation humaine tracée) |
| TP moyenne sévérité | escalade **obligatoire + oversight humain loggé** |
| Haute sévérité / incident majeur | **escalade + horloge réglementaire** (DORA 4 h / NIS2 24 h) |
| Donnée réglementée / hors résidence | **refus/handoff** (ValidationGuard bloque permanent) |

---

## 6. Architecture — Comment les Profiles sont Stockés

### 6.1 Schéma conceptuel

```
DomainPack (cyber)
    │
    ├── SemanticTree (tronc SOC L1) — UNIQUE, partagé
    │
    ├── PackConfig (racine)
    │   ├── mastery_threshold: 0.70
    │   ├── smi_weights: [...]
    │   └── helm_axes: [...]
    │
    ├── ProfileConfig(mssp_mdr)     ← 4 providers profile-aware
    │   ├── ProofRubric weights      ← w_speed élevé, w_audit optionnel
    │   ├── ValidationGuard rules    ← séparation recommandée
    │   ├── Corpus mix               ← playbooks standardisés
    │   └── Envelope ceiling         ← large
    │
    └── ProfileConfig(regulated_internal)  ← 4 providers profile-aware
        ├── ProofRubric weights      ← w_justification élevé, w_audit bloquant
        ├── ValidationGuard rules    ← séparation stricte + résidence
        ├── Corpus mix               ← SOP internes + NIS2/DORA
        └── Envelope ceiling         ← strict
```

### 6.2 Table `scy_deployment_profiles`

```sql
CREATE TABLE scy_deployment_profiles (
    id UUID PRIMARY KEY DEFAULT gen_uuid_v7(),
    organization_id UUID NOT NULL REFERENCES scy_organizations(id),
    profile_ref TEXT NOT NULL CHECK (profile_ref IN ('mssp_mdr', 'regulated_internal')),
    config JSONB NOT NULL DEFAULT '{}',     -- vecteurs de poids + bornes envelope
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL,
    UNIQUE(organization_id, profile_ref)
);
```

### 6.3 Résolution PackConfig par profil

Règles de résolution (cascade) :
1. Learner → interroge d'abord sa config propre, puis remonte à Organization, puis à DomainPack
2. Organization → interroge d'abord `scy_deployment_profiles` (son profil), puis remonte au DomainPack
3. DomainPack → config racine (pas d'héritage)

---

## 7. Implications Commerciales

| Aspect | MSSP/MDR | SOC interne régulé |
|---|---|---|
| **Pricing** | Team : 5 000 $/an (5-20 analysts) | Enterprise : 25 000 $/an (50+ analysts) |
| **Vente** | Cycle court, proof POC rapide | Cycle long, conformité comme levier |
| **Expansion** | Volume (former plus de L1) | B2B2C (tous employés) |
| **Compliance** | NIS2 générique | Sectoriel (HDS, PCI-DSS, finance) |
| **Flywheel** | Pas de B2B2C | RSSI déploie pour 200 employés après SOC |

---

## 8. Tests de Vérité — Profile-Aware

| Test | Question | Réponse attendue |
|---|---|---|
| **Test de profil** | « Si je change le profile_ref d'une org, le même Semantic Tree produit-il des preuves d'autonomie différentes ? » | **Oui** — mêmes nœuds, poids différents, bornes différentes. Pas deux arbres, un seul arbre + deux lentilles. |
| **Test d'indépendance** | « Si je retire le profil régulé, le pack MSSP/MDR fonctionne-t-il ? » | **Oui** — le pack racine (MSSP/MDR) est autonome. |

---

## 9. Reste à Durcir

- [ ] Calibrer les vecteurs de poids ProofRubric avec un design partner MSSP
- [ ] Calibrer les mêmes poids avec un RSSI régulé
- [ ] Formaliser les `ceilingMode` par classe d'alerte pour chaque profil
- [ ] Valider les règles ValidationGuard additionnelles avec un juriste conformité
- [ ] Décider si un org peut switcher de profil en cours de contrat (et l'impact sur l'Autonomy Envelope existante)

---

*Fin du document. Ce document fige les 2 profils de déploiement et leurs impacts sur les 4 providers profile-aware. Toute modification de profil doit être tracée via EventBus (PackConfigChanged).*
