# Dynatrace SLO Configuration

This repository manages Dynatrace SLOs (Service Level Objectives) via Terraform. For each service you define, it automatically creates an **availability SLO** and a **performance SLO**.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- A Dynatrace environment with API access

## Generate an API Token

1. In your Dynatrace environment, go to **Access Tokens** (Settings > Integration > Access tokens, or use the search bar).
2. Click **Generate new token**.
3. Give it a name (e.g. `terraform`).
4. Select the following scopes:
   - `Read SLO` (`slo.read`)
   - `Write SLO` (`slo.write`)
5. Click **Generate token** and copy the value.

## Export Environment Variables

The Dynatrace Terraform provider reads these environment variables by default:

```sh
export DYNATRACE_ENV_URL="https://<your-environment>.live.dynatrace.com"
export DYNATRACE_API_TOKEN="dt0c01.XXXXXXXX.YYYYYYYY"
```

Setting these avoids having to pass `-var` flags on every command.

## Deploy

```sh
terraform init
terraform plan
terraform apply
```

## Add or Modify Services

Edit `services.tf` and add entries to the `local.services` list. Each entry only requires a `name` — all other fields have defaults:

```hcl
locals {
  services = [
    { name = "CheckoutService" },
    { name = "PaymentService" },
    {
      name                        = "OrderService"
      availability_target_success = 99.95
      availability_target_warning = 99.98
      performance_threshold_us    = 500000 # 500ms
    },
  ]
}
```

### Available overrides per service

| Field | Default | Description |
|---|---|---|
| `evaluation_window` | `"-7d"` | SLO evaluation window |
| `availability_target_success` | `99.9` | Availability SLO success target (%) |
| `availability_target_warning` | `99.95` | Availability SLO warning target (%) |
| `performance_target_success` | `95` | Performance SLO success target (%) |
| `performance_target_warning` | `97` | Performance SLO warning target (%) |
| `performance_threshold_us` | `1000000` | Response time threshold in microseconds (1s) |

> **Note:** `target_warning` must be greater than `target_success` for each SLO.

After editing, run `terraform plan` to preview and `terraform apply` to deploy.
