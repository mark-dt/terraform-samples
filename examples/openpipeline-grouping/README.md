# OpenPipeline Pipeline Grouping Sample

Sample Terraform configuration showing how to group Dynatrace OpenPipeline log pipelines and route data into them.

It creates:

- **One custom log pipeline per team** (`dynatrace_openpipeline_v2_logs_pipelines`), each with a `costAllocation` and `productAllocation` processor that stamp `dt.cost.costcenter` / `dt.cost.product` on ingested logs. The values must match the account-level cost center and product keys managed by the root module (`cost_centers` / `cost_products`).
- **A pipeline group** (`dynatrace_openpipeline_v2_logs_pipelinegroups`) wrapping the team pipelines with a shared stage configuration.
- **Routing rules** (`dynatrace_openpipeline_v2_logs_routing`) that send logs to the right team pipeline based on `k8s.namespace.name`.

## Usage

The provider reads credentials from the environment:

```sh
export DYNATRACE_ENV_URL="https://<your-environment>.live.dynatrace.com"
export DYNATRACE_API_TOKEN="dt0c01.XXXXXXXX.YYYYYYYY"

terraform init
terraform plan
terraform apply
```

Adjust the `teams` map in `main.tf` to your own teams: display name, namespace matcher, cost center, and product.

> **Note:** the routing resource manages the custom routing table for logs — review the plan carefully if routing rules already exist in your environment.
