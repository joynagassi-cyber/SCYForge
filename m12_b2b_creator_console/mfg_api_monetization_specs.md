# 🔌 MINDFORGE API PLATFORM — B2B API-AS-A-SERVICE & MONETIZATION SPECS
**ID Module** : M12_B2B_CREATOR_CONSOLE_API  
**Statut** : 🟢 SPÉCIFICATION TECHNIQUE DÉPLOYABLE (WEB-FIRST PHASE 1)  

---

## 1. Vision d'Affaires & Monétisation
Pour maximiser la rentabilité de MindForge et offrir aux créateurs de contenu et aux plateformes tierces la possibilité de s'intégrer nativement dans notre écosystème d'apprentissage, MindForge expose ses moteurs sémantiques sous forme d'**APIs cloud-native sécurisées et facturées à l'usage (SaaS API)**.

### Modèle de Tarification (Usage-Based Pricing) :
* **Ingestion API** : 0.05$ par page PDF ou 10 minutes d'audio (géré par Docling/Whisper).
* **FSRS-as-a-Service API** : 0.01$ par lot de 100 calculs d'intervalles de mémorisation.
* **Neuro-Graph-as-a-Service API** : 0.10$ par génération de layout spatial de cerveau 3D/2D.

---

## 2. Spécification des Endpoints de Production

### 2.1 Ingestion Sémantique API (`POST /v1/api/ingest`)
Permet d'envoyer un document ou un lien brute pour le convertir en Markdown sémantique épuré d'inscriptions et le vectoriser.
* **Payload de requête** :
```json
{
  "source_url": "https://arxiv.org/pdf/1712.01856.pdf",
  "document_type": "academic",
  "tenant_id": "creator_alexis_cohort_01"
}
```
* **Réponse de production** :
```json
{
  "document_id": "7c2f35b5-180a-41cd-bc65-38749fbd64b0",
  "pages_count": 30,
  "markdown_preview": "# Attention is All You Need...",
  "status": "indexed"
}
```

### 2.2 FSRS Scheduler API (`POST /v1/api/fsrs/next-state`)
Calcule le prochain état de rétention d'une carte mémoire pour un utilisateur externe.
* **Payload de requête** :
```json
{
  "card_id": "card-992",
  "rating": 3, 
  "state": {
    "stability": 2.4,
    "difficulty": 4.8,
    "elapsed_days": 3,
    "scheduled_days": 3,
    "reps": 2,
    "lapses": 0
  }
}
```
* **Réponse de production** :
```json
{
  "next_state": {
    "stability": 6.82,
    "difficulty": 4.65,
    "elapsed_days": 0,
    "scheduled_days": 7,
    "reps": 3,
    "lapses": 0
  }
}
```

---

## 3. Sécurité, RLS et Throttling (LiteLLM Integration)
Chaque requête API est vérifiée en amont par notre proxy **LiteLLM**. Les quotas et clés d'accès sont gérés de façon asynchrone, consignant l'usage dans la table `mfg_llm_spend_log` pour s'assurer qu'un utilisateur ne dépasse jamais son enveloppe.
