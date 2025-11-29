# Architecture détaillée

## Vue d'ensemble

Le système Event-Driven GCP implémente une architecture événementielle complète sur Google Cloud Platform, avec une séparation claire des responsabilités et une haute disponibilité.

## Composants

### 1. Google Cloud Pub/Sub

**Rôle** : File de messages pour l'ingestion d'événements

- Topic : `event-ingestion-{env}`
- Messages au format CloudEvent
- Données encodées en base64
- Garanties de livraison at-least-once

### 2. Eventarc

**Rôle** : Routage d'événements vers Cloud Run

- Intégration native avec Cloud Run
- Filtrage basé sur les attributs CloudEvent
- Transport via Pub/Sub
- Configuration :
```hcl
destination {
  cloud_run_service {
    service = "event-driven-api-{env}"
    path    = "/api/v1/ingest_event"
    region  = "europe-west1"
  }
}
```

### 3. Cloud Run

**Rôle** : Hébergement de l'API FastAPI

- Scaling automatique (0 → N instances)
- Container : Image Docker multi-tag
- Service Account avec permissions limitées
- Endpoint : `/api/v1/ingest_event`

### 4. Google Secret Manager

**Rôle** : Stockage sécurisé des tokens

- Secret : `LOGFIRE_TOKEN_EVENT_DRIVEN_TEMPLATE`
- Accès via service account
- Cache applicatif avec `@lru_cache`
- Récupération à chaud au démarrage

### 5. Google Cloud Storage

**Rôle** : Stockage Delta Lake

- Bucket : `event-driven`
- Path : `gs://event-driven/ingest_table/`
- Format : Delta Lake (Parquet + transaction log)
- Permissions : `roles/storage.objectAdmin`

### 6. Delta Lake

**Rôle** : Couche ACID sur GCS

- Tables versionnées
- Support des transactions ACID
- Time-travel queries
- Optimisation automatique (compact + vacuum)

## Flux de données détaillé

```
┌─────────────────────────────────────────────────────────────────┐
│                        Event Publisher                          │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ Publish event
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Pub/Sub Topic                              │
│                  event-ingestion-dev                            │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ CloudEvent
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Eventarc                                 │
│        (Event Routing & Filtering)                              │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ HTTP POST
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Cloud Run Service                           │
│                  event-driven-api-dev                           │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ 1. Retrieve Logfire Token from Secret Manager (cached)   │ │
│  └────────────────────────┬──────────────────────────────────┘ │
│                           │                                     │
│  ┌────────────────────────▼──────────────────────────────────┐ │
│  │ 2. Decode base64 CloudEvent data                         │ │
│  └────────────────────────┬──────────────────────────────────┘ │
│                           │                                     │
│  ┌────────────────────────▼──────────────────────────────────┐ │
│  │ 3. Generate unique ID (SHA256 of content)                │ │
│  └────────────────────────┬──────────────────────────────────┘ │
│                           │                                     │
│  ┌────────────────────────▼──────────────────────────────────┐ │
│  │ 4. Validate with Pydantic (EventModelV1)                 │ │
│  └────────────────────────┬──────────────────────────────────┘ │
│                           │                                     │
│  ┌────────────────────────▼──────────────────────────────────┐ │
│  │ 5. Create Polars DataFrame                               │ │
│  └────────────────────────┬──────────────────────────────────┘ │
│                           │                                     │
│  ┌────────────────────────▼──────────────────────────────────┐ │
│  │ 6. Check Delta Table existence on GCS                    │ │
│  └────────────────────────┬──────────────────────────────────┘ │
│                           │                                     │
│                 ┌─────────┴──────────┐                         │
│                 │                    │                         │
│          Table Exists         Table Not Exists                │
│                 │                    │                         │
│  ┌──────────────▼──────────┐  ┌──────▼─────────────────────┐ │
│  │ 7a. Merge (UPSERT)      │  │ 7b. Create new table       │ │
│  │     on target.id=source │  │                            │ │
│  └──────────────┬──────────┘  └──────┬─────────────────────┘ │
│                 │                    │                         │
│                 └─────────┬──────────┘                         │
│                           │                                     │
│  ┌────────────────────────▼──────────────────────────────────┐ │
│  │ 8. Optimize: Compact + Vacuum                            │ │
│  └────────────────────────┬──────────────────────────────────┘ │
│                           │                                     │
│  ┌────────────────────────▼──────────────────────────────────┐ │
│  │ 9. Log to Logfire & Loguru                               │ │
│  └────────────────────────┬──────────────────────────────────┘ │
└────────────────────────────┼─────────────────────────────────────┘
                            │
                            │ Success response
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GCS - Delta Lake                             │
│                gs://event-driven/ingest_table/                  │
│                                                                 │
│  _delta_log/                                                    │
│  ├── 00000000000000000000.json                                 │
│  └── 00000000000000000001.json                                 │
│                                                                 │
│  data/                                                          │
│  ├── part-00000-*.parquet                                      │
│  └── part-00001-*.parquet                                      │
└─────────────────────────────────────────────────────────────────┘
```

## Gestion des doublons

### Problème

Les IDs Pub/Sub (`messageId`) et CloudEvent (`ce-id`) changent à chaque publication/livraison, même pour un contenu identique :

```
Event 1: messageId=123, ce-id=abc, content={name:"John"}
Event 2: messageId=456, ce-id=def, content={name:"John"}  ← Doublon !
```

### Solution : Hash du contenu

Génération d'un ID déterministe basé sur le contenu :

```python
def generate_unique_id(data: dict) -> str:
    sorted_data = json.dumps(data, sort_keys=True)
    return hashlib.sha256(sorted_data.encode()).hexdigest()
```

**Résultat** :
```
Event 1: id=hash(content), content={name:"John"}
Event 2: id=hash(content), content={name:"John"}  ← Même ID !
```

Delta Lake merge sur `target.id = source.id` → Pas de doublon ✅

## Sécurité

### Principe du moindre privilège

Chaque service account a uniquement les permissions nécessaires :

**cloudrun-runtime-{env}** :
```hcl
roles/secretmanager.secretAccessor  # Lire les secrets
roles/storage.objectAdmin           # Lire/écrire Delta Lake
roles/bigquery.jobUser             # Optionnel : requêtes BigQuery
```

**eventarc-triggers-{env}** :
```hcl
roles/eventarc.eventReceiver  # Recevoir les événements
roles/run.invoker            # Déclencher Cloud Run
roles/pubsub.subscriber      # S'abonner au topic
```

### Secrets

Tokens stockés dans Secret Manager :
- Chiffrement au repos
- Contrôle d'accès IAM
- Audit des accès
- Rotation possible sans redéploiement

## Observabilité

### Logs structurés

```python
logger.info(f"🗓️ CloudEvent Pub/Sub decoded: {data_decoded}")
logger.info(f"🆔 ID unique généré: {unique_id}")
logger.info(f"🔖 CE-ID original: {request.headers.get('ce-id')}")
logger.info(f"🏷️ Type (ce-type): {request.headers.get('ce-type')}")
```

### Métriques Logfire

- Latence des requêtes
- Nombre d'événements ingérés
- Taux d'erreur
- Taille des batches Delta Lake

## CI/CD

### Pipeline GitHub Actions

```yaml
1. Tests & Type Checking
   └─ pytest, mypy, ruff

2. Terraform - Artifact Registry
   └─ terraform apply (module.artifactory)

3. Docker Build & Push
   ├─ Tag: {SHA}
   ├─ Tag: {YYYYMMDD-HHMMSS}
   └─ Tag: latest

4. Terraform - Full Stack
   └─ terraform apply (all modules)

5. MkDocs Deployment
   └─ mkdocs gh-deploy --force
```

### Tags Docker

Stratégie multi-tag pour traçabilité :

- `2409e1b` : Commit exact (debugging)
- `20251128-153000` : Horodatage (chronologie)
- `latest` : Dernière version stable (développement)

## Scalabilité

### Horizontal Scaling (Cloud Run)

- Min instances : 0 (cold start acceptable)
- Max instances : Auto (défini par quota GCP)
- Concurrency : 80 requêtes/container
- CPU : 1 vCPU, Memory : 512 Mi

### Delta Lake Optimization

- **Compact** : Fusionne les petits fichiers Parquet
- **Vacuum** : Supprime les fichiers obsolètes
- Exécuté après chaque ingestion
- Améliore les performances de lecture

## Monitoring & Alerting

### Métriques recommandées

- **Latence p50/p95/p99** : Temps de traitement
- **Throughput** : Événements/seconde
- **Error Rate** : % d'erreurs HTTP 5xx
- **Delta Table Size** : Croissance du stockage
- **Cold Start Duration** : Temps de démarrage Cloud Run

### Alertes suggérées

- Error rate > 5%
- Latency p95 > 2s
- No events ingested for 5 minutes
- Delta table size > threshold

## Disaster Recovery

### Backup

- Delta Lake : Time-travel jusqu'à 30 jours
- Secrets : Versioning automatique
- Infrastructure : Code Terraform versionné

### Recovery

```bash
# Restaurer une version antérieure
dt = DeltaTable("gs://event-driven/ingest_table")
dt.load_version(version_number)

# Ou restaurer à une date
dt.load_as_of(datetime(2025, 11, 28))
```

## Évolutions futures

- [ ] Support multi-topic avec routage dynamique
- [ ] Compression des événements (gzip)
- [ ] Partitionnement Delta Lake par date
- [ ] Cache Redis pour la déduplication
- [ ] Support des schémas Avro/Protobuf
- [ ] Métriques custom dans Logfire
- [ ] Dead Letter Queue pour erreurs

