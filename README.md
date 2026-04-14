# Dynatrace Basic Templates

This repository will help you deploy a few basic templates and allow you to have a headstart when working with Terraform and Dynatrace. All configuration is deployed automatically using **Terraform**.

## Cost allocation

The repository now includes the account-level cost allocation configuration from [`tf-cost-allocation`](/Users/mark/workspace/terraform-samples/tf-cost-allocation/main.tf). It is disabled by default and can be enabled from the root module with:

```hcl
enable_cost_allocation        = true
dynatrace_account_uuid        = "00000000-0000-0000-0000-000000000000"
dynatrace_oauth_client_id     = "your-client-id"
dynatrace_oauth_client_secret = "your-client-secret"
cost_centers                  = ["engineering", "marketing"]
cost_products                 = ["checkout", "mobile-app"]
```

The integration uses the Dynatrace account API at `dynatrace_api_base` and requires OAuth credentials that can request the `account-uac-write` scope.


