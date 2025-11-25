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
- Base64 decoding and data transformation
- Pydantic-based data validation

### 🗄️ Delta Lake Storage
- ACID-compliant storage on GCS
- Automatic UPSERT (merge) operations
- Schema evolution support
- Time-travel capabilities for historical queries

### ⚡ Performance Optimization
- Automatic table compaction after ingestion
- Vacuum operations to clean up old files
- Efficient merge operations based on unique IDs
- Optimized for high-throughput workloads

### 📊 Observability
- Structured logging with Loguru
- Real-time monitoring with Logfire
- CloudEvent tracking with ce-id and ce-type headers
- Comprehensive error handling and reporting

### 🏗️ Infrastructure as Code
- Complete Terraform modules for GCP resources
- Modular architecture with reusable components
- Support for multiple environments (dev, prod)
- Automated CI/CD with GitHub Actions

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
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "John",
  "lastname": "Doe"
}
```

The `id` field is extracted from the `ce-id` header and used for UPSERT operations.

## Data Flow

1. **Event Reception**: CloudEvent arrives via Pub/Sub push subscription
2. **Validation**: Headers and payload are validated
3. **Decoding**: Base64 data is decoded to JSON
4. **Transformation**: Data is mapped to Pydantic model
5. **Storage Decision**: Check if Delta table exists
6. **Merge/Insert**: Perform UPSERT or create new table
7. **Optimization**: Run compaction and vacuum
8. **Response**: Return success status with processed data

## Next Steps

- [API Reference](modules.md) - Detailed API documentation
- [Contributing](https://github.com/jojo/event-driven-gcp/blob/main/CONTRIBUTING.md) - Contribution guidelines
- [Infrastructure Guide](https://github.com/jojo/event-driven-gcp/blob/main/infra/USAGE.md) - Terraform module usage
