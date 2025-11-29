# Event-Driven GCP Documentation

[![Release](https://img.shields.io/github/v/release/jojo/event-driven-gcp)](https://img.shields.io/github/v/release/jojo/event-driven-gcp)
[![Build status](https://img.shields.io/github/actions/workflow/status/jojo/event-driven-gcp/main.yml?branch=main)](https://github.com/jojo/event-driven-gcp/actions/workflows/main.yml?query=branch%3Amain)
[![Commit activity](https://img.shields.io/github/commit-activity/m/jojo/event-driven-gcp)](https://img.shields.io/github/commit-activity/m/jojo/event-driven-gcp)
[![License](https://img.shields.io/github/license/jojo/event-driven-gcp)](https://img.shields.io/github/license/jojo/event-driven-gcp)

Welcome to the Event-Driven GCP documentation! This project provides a complete event-driven architecture implementation on Google Cloud Platform.

## Overview

Event-Driven GCP is a production-ready system for ingesting CloudEvents from Google Cloud Pub/Sub and storing them in Delta Lake format on Google Cloud Storage. The architecture is fully serverless, scalable, and built with modern best practices.

## Key Features

### 🎯 Event Ingestion
- Receive CloudEvents via Google Cloud Pub/Sub
- Automatic CloudEvent validation and parsing
- Base64 decoding and JSON data transformation
- Pydantic-based data validation
- Content-based unique ID generation (SHA256 hash)

### 🗄️ Delta Lake Storage
- ACID-compliant storage on GCS
- Automatic UPSERT (merge) operations based on content hash
- Schema evolution support
- Time-travel capabilities for historical queries
- Automatic deduplication of identical events

### ⚡ Performance Optimization
- High-performance data processing with Polars DataFrames
- Automatic table compaction after ingestion
- Vacuum operations to clean up old files
- Efficient merge operations based on unique IDs
- Optimized for high-throughput workloads

### 🔐 Security & Secrets
- Secure token storage via Google Secret Manager
- Least-privilege IAM service accounts
- GCS object-level access control
- Runtime secret retrieval with caching

### 📊 Observability
- Structured logging with Loguru
- Real-time monitoring with Logfire
- CloudEvent tracking with ce-id and ce-type headers
- Content hash logging for traceability
- Comprehensive error handling and reporting

### 🏗️ Infrastructure as Code
- Complete Terraform modules for GCP resources
- Native Cloud Run service integration with Eventarc
- Modular architecture with reusable components
- Support for multiple environments (dev, prod)
- Automated CI/CD with GitHub Actions
- Multi-tag Docker images (SHA, timestamp, latest)

## Architecture

The system follows a clean event-driven architecture:

```
┌─────────────┐     ┌──────────┐     ┌────────────┐     ┌────────────┐
│   Events    │────▶│  Pub/Sub │────▶│  Eventarc  │────▶│ Cloud Run  │
└─────────────┘     └──────────┘     └────────────┘     └─────┬──────┘
                                                                │
                                                                ▼
                                                         ┌──────────────┐
                                                         │  Delta Lake  │
                                                         │    (GCS)     │
                                                         └──────────────┘
```

### Components

- **Pub/Sub**: Message queue for event ingestion
- **Eventarc**: Event routing and filtering
- **Cloud Run**: Serverless container runtime for the FastAPI application
- **Delta Lake**: ACID-compliant data lake storage on GCS
- **Logfire**: Observability and monitoring platform

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/jojo/event-driven-gcp.git
cd event-driven-gcp

# Install dependencies
make install

# Run locally
uv run uvicorn api.app:app --reload
```

### API Usage

Send a CloudEvent to the ingestion endpoint:

```bash
curl -X POST http://localhost:8000/api/v1/ingest_event \
  -H "Content-Type: application/json" \
  -H "ce-id: 550e8400-e29b-41d4-a716-446655440000" \
  -H "ce-type: com.example.event.v1" \
  -d '{
    "message": {
      "data": "eyJuYW1lIjogIkpvaG4iLCAibGFzdG5hbWUiOiAiRG9lIn0="
    }
  }'
```

Response:
```json
{
  "status": "success",
  "message_data": "{\"name\": \"John\", \"lastname\": \"Doe\"}"
}
```

## Infrastructure Deployment

### Prerequisites

- Google Cloud SDK
- Terraform >= 1.0
- Appropriate GCP permissions

### Deploy

```bash
cd infra

# Initialize Terraform with backend
terraform init -backend-config=backend/dev.gcs.backend

# Review changes
terraform plan

# Apply infrastructure
terraform apply
```

## Configuration

The application is configured via environment variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `API_V1_STR` | API prefix path | No (default: `/api/v1`) |
| `LOGFIRE_TOKEN` | Logfire authentication token | Yes |

## Event Model

Events must conform to the `EventModelV1` schema:

```python
{
  "id": "a1b2c3d4e5f6...",  # SHA256 hash of event content
  "name": "John",
  "lastname": "Doe"
}
```

### Unique ID Generation

The `id` field is generated using a SHA256 hash of the event content for deterministic deduplication:

```python
import hashlib
import json

def generate_unique_id(data: dict) -> str:
    """Generate deterministic ID from event content."""
    sorted_data = json.dumps(data, sort_keys=True)
    return hashlib.sha256(sorted_data.encode()).hexdigest()
```

**Benefits:**
- Same content always produces the same ID (idempotent)
- Prevents duplicate event ingestion
- Independent of Pub/Sub `messageId` or `ce-id`
- Content-based deduplication at business logic level

## Data Flow

1. **Event Reception**: CloudEvent arrives via Eventarc → Cloud Run
2. **Secret Retrieval**: Logfire token fetched from Google Secret Manager (cached)
3. **Validation**: Headers and payload are validated
4. **Decoding**: Base64 data is decoded to JSON
5. **ID Generation**: Unique ID computed from content hash (SHA256)
6. **Transformation**: Data is mapped to Pydantic model
7. **DataFrame Creation**: Polars DataFrame constructed from validated data
8. **Storage Decision**: Check if Delta table exists on GCS
9. **Merge/Insert**: Perform UPSERT (merge on ID) or create new table
10. **Optimization**: Run compaction and vacuum operations
11. **Logging**: Event tracked with Logfire and Loguru
12. **Response**: Return success status with processed data

## Security Architecture

### Secret Management

```python
from api.utils.secrets import get_secret_from_gcp

# Retrieve secrets at runtime
logfire_token = get_secret_from_gcp(
    project_id="dataascode",
    secret_name="LOGFIRE_TOKEN_EVENT_DRIVEN_TEMPLATE"
)
```

### IAM Roles

**Cloud Run Service Account:**
- `roles/secretmanager.secretAccessor` - Read secrets
- `roles/storage.objectAdmin` - Read/write Delta Lake files
- `roles/bigquery.jobUser` - Query BigQuery (if needed)

**Eventarc Service Account:**
- `roles/eventarc.eventReceiver` - Receive events from Pub/Sub
- `roles/run.invoker` - Trigger Cloud Run services
- `roles/pubsub.subscriber` - Subscribe to Pub/Sub topics

## Technology Deep Dive

### Polars Integration

High-performance DataFrame processing for event transformation:

```python
import polars as pl

# Create DataFrame from Pydantic model
df = pl.DataFrame(data_to_ingest.model_dump(by_alias=True))

# Convert to PyArrow for Delta Lake compatibility
source_data = df.to_arrow()
```

### Delta Lake Operations

ACID-compliant UPSERT operations with automatic optimization:

```python
dt.merge(
    source=source_data,
    predicate="target.id = source.id",  # Match on content hash
    source_alias="source",
    target_alias="target",
    merge_schema=True,
)
.when_matched_update_all(except_cols=["id"])  # Update all except ID
.when_not_matched_insert_all()  # Insert new records
.execute()

# Optimize storage
dt.optimize.compact()
dt.vacuum(retention_hours=0, enforce_retention_duration=False)
```

## Next Steps

- [API Reference](modules.md) - Detailed API documentation
- [Contributing](https://github.com/jojo/event-driven-gcp/blob/main/CONTRIBUTING.md) - Contribution guidelines
- [Infrastructure Guide](https://github.com/jojo/event-driven-gcp/blob/main/infra/USAGE.md) - Terraform module usage
