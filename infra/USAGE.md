# GCP Event-Driven Module Usage Guide

## 🚀 Quick Start

### 1. Set up your environment

```bash
# Clone and navigate to the project
cd infra/

# Copy the example tfvars file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your specific values
vim terraform.tfvars
```

### 2. Deploy with environment-specific configuration

```bash
# Development Environment
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"

# Production Environment
terraform plan -var-file="environments/prod.tfvars"
terraform apply -var-file="environments/prod.tfvars"

# Custom configuration
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## 📁 Project Structure

```
infra/
├── environments/
│   ├── dev.tfvars           # Development configuration
│   ├── staging.tfvars       # Staging configuration (optional)
│   └── prod.tfvars          # Production configuration
├── workflows/
│   ├── vehicle-data-processing.yaml  # Vehicle telemetry processing
│   ├── fleet-analytics.yaml          # Analytics and reporting
│   └── maintenance-alerts.yaml       # Maintenance alert handling
├── modules/
│   └── gcp-event-driven/           # Main module
├── terraform.tfvars.example       # Template for custom configurations
├── gcp_event_driven.tf            # Module instantiation
├── variables.tf                   # Variable declarations
└── USAGE.md                      # This file
```

## ⚙️ Configuration

### Environment-Specific Variables

The module uses environment-specific tfvars files to maintain separation between dev, staging, and production. Each environment can have:

- **Different GCP projects** for complete isolation
- **Different resource naming** (e.g., `fleet-api-dev` vs `fleet-api-prod`)
- **Different schedules** (e.g., every 6 hours for dev, daily for prod)
- **Different workflow configurations** using templatefile()
- **Different scaling and performance settings**

### Workflow Configuration Best Practices

✅ **DO**: Store workflow YAML in separate files
```hcl
workflows = {
  "data-processing" = {
    name         = "data-processing-${var.environment}"
    description  = "Vehicle data processing for ${var.environment}"
    workflow_content = templatefile("${path.module}/workflows/data-processing.yaml", {
      API_URL     = "https://api-${var.environment}.run.app"
      ENVIRONMENT = var.environment
      PROJECT_ID  = var.project
    })
  }
}
```

❌ **DON'T**: Embed YAML content directly in tfvars
```hcl
# This makes tfvars files huge and hard to maintain
workflow_content = <<-EOT
main:
  steps:
    - step1:
        call: ...
EOT
```

### Eventarc Trigger Patterns

**Pattern 1: Direct Cloud Run Invocation**
```hcl
cloudrun_triggers = {
  "api-events" = {
    name                 = "api-events-trigger-${var.environment}"
    label                = var.environment
    source_topic_name    = "projects/${var.project}/topics/api-events"
    target_cloudrun_name = var.name_ressource_cloud_run
  }
}
```

**Pattern 2: Workflow Orchestration**
```hcl
workflows_triggers = {
  "complex-processing" = {
    name                 = "complex-processing-${var.environment}"
    label                = var.environment
    source_topic_name    = "projects/${var.project}/topics/complex-events"
    target_workflow_name = "multi-step-processor"
  }
}
```

## 🔧 Common Use Cases

### 1. Real-time Vehicle Tracking
```bash
# Deploy with vehicle tracking configuration
terraform apply -var-file="environments/dev.tfvars" \
  -var="cloudrun_triggers={
    \"vehicle-location\" = {
      name = \"vehicle-location-tracker\"
      label = \"tracking\"
      source_topic_name = \"projects/fleet-dev/topics/vehicle-locations\"
      target_cloudrun_name = \"fleet-api-dev\"
    }
  }"
```

### 2. Maintenance Alert System
```bash
# Deploy with maintenance alerting
terraform apply -var-file="environments/prod.tfvars" \
  -var="workflows_triggers={
    \"maintenance-alerts\" = {
      name = \"maintenance-processor\"
      label = \"maintenance\"
      source_topic_name = \"projects/fleet-prod/topics/maintenance-events\"
      target_workflow_name = \"maintenance-alerts-prod\"
    }
  }"
```

### 3. Analytics Pipeline
```bash
# Deploy with analytics processing
terraform apply -var-file="environments/prod.tfvars" \
  -var="cloud_scheduler_schedule=0 1 * * *"  # Override to run at 1 AM
```

## 🔍 Verification & Testing

### Check Deployment Status
```bash
# Verify Cloud Run services
gcloud run services list --region=europe-west1

# Check Eventarc triggers
gcloud eventarc triggers list --location=europe-west1

# View workflows
gcloud workflows list --location=europe-west1

# Check Cloud Scheduler jobs
gcloud scheduler jobs list --location=europe-west1
```

### Test Event Processing
```bash
# Publish a test message to Pub/Sub
gcloud pubsub topics publish fleet-events-dev \
  --message='{"vehicle_id":"TEST-001","event_type":"location_update","timestamp":"2024-01-01T12:00:00Z"}'

# Check workflow execution logs
gcloud workflows executions list \
  --workflow=vehicle-data-processing-dev \
  --location=europe-west1
```

## 🛡️ Security Considerations

### Service Account Management
- Each environment uses separate service accounts
- Minimal required permissions are granted
- Service account keys are stored in Secret Manager
- Use Workload Identity when possible instead of service account keys

### Network Security
- All communication over HTTPS/TLS
- Pub/Sub messages encrypted in transit and at rest
- VPC-native deployments for enhanced security (configure separately)

### Secret Management
```bash
# Access secrets from Cloud Run (example)
export SECRET_VALUE=$(gcloud secrets versions access latest --secret="dbt-service-key-dev")
```

## 📊 Monitoring & Observability

### Using Module Outputs for Monitoring
```hcl
# Create alerts based on module outputs
resource "google_monitoring_alert_policy" "cloudrun_alerts" {
  display_name = "${var.environment}-fleet-api-alerts"

  conditions {
    display_name = "High Error Rate"
    condition_threshold {
      filter = "resource.type=\"cloud_run_revision\" resource.label.service_name=\"${module.gcp_event_driven.cloudrun_service_name}\""
      comparison = "COMPARISON_GREATER_THAN"
      threshold_value = 0.05
    }
  }
}
```

### Key Metrics to Monitor
- Cloud Run request latency and error rates
- Pub/Sub message backlog and processing time
- Workflow execution success/failure rates
- BigQuery job performance and costs
- Eventarc trigger execution metrics

## 🚨 Troubleshooting

### Common Issues & Solutions

**Issue**: Eventarc trigger fails with permission error
```bash
# Solution: Check service account permissions
gcloud projects get-iam-policy YOUR-PROJECT-ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:eventarc-triggers@*"
```

**Issue**: Workflow execution timeout
```bash
# Solution: Check workflow logs for bottlenecks
gcloud workflows executions describe EXECUTION-ID \
  --workflow=WORKFLOW-NAME \
  --location=REGION
```

**Issue**: Cloud Run cold starts
```bash
# Solution: Configure minimum instances
gcloud run services update YOUR-SERVICE \
  --region=REGION \
  --min-instances=1
```

## 🔄 Environment Management

### Switching Between Environments
```bash
# Development deployment
terraform workspace select dev  # if using workspaces
terraform apply -var-file="environments/dev.tfvars"

# Production deployment
terraform workspace select prod
terraform apply -var-file="environments/prod.tfvars"
```

### Environment-Specific Overrides
```bash
# Override specific variables for testing
terraform apply -var-file="environments/dev.tfvars" \
  -var="cloud_scheduler_schedule=0 */1 * * *"  # Every hour for testing
```

## 📋 Deployment Checklist

### Pre-Deployment
- [ ] GCP APIs enabled
- [ ] Service account permissions configured
- [ ] Artifact Registry repository exists
- [ ] Docker images built and pushed
- [ ] Workflow YAML files validated
- [ ] Environment-specific tfvars reviewed

### Post-Deployment
- [ ] Cloud Run service responding
- [ ] Eventarc triggers active
- [ ] Workflows executable
- [ ] Pub/Sub topics created
- [ ] BigQuery dataset accessible
- [ ] Monitoring and alerting configured

### Production Deployment
- [ ] Staging environment tested successfully
- [ ] Performance testing completed
- [ ] Security review passed
- [ ] Backup and disaster recovery planned
- [ ] Monitoring dashboards configured
- [ ] On-call procedures documented

## 🔄 Updates & Maintenance

### Updating Workflow Logic
1. Modify workflow YAML files in `workflows/` directory
2. Test changes in development environment
3. Deploy to staging for validation
4. Deploy to production with proper change management

### Updating Module Configuration
1. Modify environment-specific tfvars files
2. Run `terraform plan` to review changes
3. Apply changes during maintenance windows
4. Verify all services are functioning correctly

### Version Management
- Use specific commit SHAs for production deployments
- Tag releases for major version changes
- Maintain backward compatibility when possible
- Document breaking changes in release notes
