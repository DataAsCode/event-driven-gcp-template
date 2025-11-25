# Event-Driven GCP 🚀

[![Release](https://img.shields.io/github/v/release/jojo/event-driven-gcp)](https://img.shields.io/github/v/release/jojo/event-driven-gcp)
[![Build status](https://img.shields.io/github/actions/workflow/status/jojo/event-driven-gcp/main.yml?branch=main)](https://github.com/jojo/event-driven-gcp/actions/workflows/main.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/jojo/event-driven-gcp/branch/main/graph/badge.svg)](https://codecov.io/gh/jojo/event-driven-gcp)
[![Commit activity](https://img.shields.io/github/commit-activity/m/jojo/event-driven-gcp)](https://img.shields.io/github/commit-activity/m/jojo/event-driven-gcp)
[![License](https://img.shields.io/github/license/jojo/event-driven-gcp)](https://img.shields.io/github/license/jojo/event-driven-gcp)

An event-driven architecture implementation on Google Cloud Platform that ingests CloudEvents from Pub/Sub and stores them in Delta Lake format on GCS.

- **Github repository**: <https://github.com/jojo/event-driven-gcp/>
- **Documentation**: <https://jojo.github.io/event-driven-gcp/>

## Features

- ✨ **CloudEvent Ingestion**: Receive and process CloudEvents via Google Cloud Pub/Sub
- 🗄️ **Delta Lake Storage**: ACID-compliant storage with merge and time-travel capabilities
- 🔄 **Automatic UPSERT**: Intelligent event merging based on unique IDs
- ⚡ **Auto-Optimization**: Automatic table compaction and vacuum after ingestion
- 📊 **Observability**: Structured logging with Logfire and Loguru integration
- 🏗️ **Infrastructure as Code**: Complete Terraform modules for GCP deployment
- 🐳 **Containerized**: Docker-ready with Cloud Run deployment support
- 🔐 **Secure**: Service account-based authentication and authorization

## Architecture

```
Pub/Sub Topic → Eventarc → Cloud Run (FastAPI) → Delta Lake (GCS)
                                  ↓
                              Logfire (Observability)
```

The system follows an event-driven pattern where:
1. Events are published to a Pub/Sub topic
2. Eventarc triggers the Cloud Run service
3. FastAPI API receives the CloudEvent
4. Data is decoded and validated with Pydantic
5. Events are upserted into Delta Lake tables on GCS
6. Tables are automatically optimized (compact + vacuum)

## Quick Start

### Prerequisites

- Python 3.11+
- [uv](https://github.com/astral-sh/uv) package manager
- Google Cloud SDK (for deployment)
- Terraform (for infrastructure)

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/jojo/event-driven-gcp.git
   cd event-driven-gcp
   ```

2. **Install dependencies**
   ```bash
   make install
   ```

3. **Run the API locally**
   ```bash
   uv run uvicorn api.app:app --reload
   ```

4. **Run tests**
   ```bash
   make test
   ```

### Infrastructure Deployment

1. **Configure GCP backend**
   ```bash
   cd infra
   # Edit backend configuration
   terraform init -backend-config=backend/dev.gcs.backend
   ```

2. **Deploy infrastructure**
   ```bash
   terraform plan
   terraform apply
   ```

3. **Deploy the API**
   ```bash
   make deploy
   ```

## Project Structure

```
event-driven-gcp/
├── api/                      # FastAPI application
│   ├── routers/             # API endpoints
│   ├── models/              # Pydantic models
│   ├── docs/                # OpenAPI documentation
│   └── utils/               # Configuration and utilities
├── infra/                   # Terraform infrastructure
│   ├── modules/             # Reusable Terraform modules
│   │   ├── event-driven-stack/
│   │   │   ├── cloud_run/
│   │   │   ├── eventarc/
│   │   │   ├── pubsub/
│   │   │   └── service_account/
│   │   └── artifactory/
│   └── backend/             # Terraform backend configs
├── tests/                   # Test suite
└── docs/                    # MkDocs documentation
```

## API Endpoints

### `POST /api/v1/ingest_event`

Ingests CloudEvents from Pub/Sub into Delta Lake.

**Request Example:**
```json
{
  "message": {
    "data": "eyJuYW1lIjogIkpvaG4iLCAibGFzdG5hbWUiOiAiRG9lIn0=",
    "messageId": "123456789",
    "publishTime": "2025-11-24T10:00:00Z"
  }
}
```

**Response:**
```json
{
  "status": "success",
  "message_data": "{\"name\": \"John\", \"lastname\": \"Doe\"}"
}
```

## Configuration

Configuration is managed via environment variables:

```bash
API_V1_STR="/api/v1"              # API prefix
LOGFIRE_TOKEN="your-token"         # Logfire observability token
```

## Development

### Code Quality

```bash
# Run linting
make check

# Format code
uv run ruff format .

# Type checking
uv run mypy .
```

### Testing

```bash
# Run all tests
make test

# Run with coverage
make test-cov
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [FastAPI](https://fastapi.tiangolo.com/)
- Storage powered by [Delta Lake](https://delta.io/)
- Deployed on [Google Cloud Platform](https://cloud.google.com/)
- Observability with [Logfire](https://logfire.pydantic.dev/)
