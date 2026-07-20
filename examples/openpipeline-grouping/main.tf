# Sample OpenPipeline configuration for pipeline grouping.
#
# Creates one custom log pipeline per team, each stamping the cost center and
# product used for cost allocation (see the account-level keys managed by the
# root module in ../../tf-cost-allocation), wraps them in a pipeline group,
# and routes logs to the right pipeline by Kubernetes namespace.

locals {
  # One entry per team pipeline. cost_center and product must match keys
  # configured at account level (cost_centers / cost_products in the root module).
  teams = {
    payments = {
      display_name = "Payments logs"
      namespace    = "payments"
      cost_center  = "engineering"
      product      = "payments-api"
    }
    checkout = {
      display_name = "Checkout logs"
      namespace    = "checkout"
      cost_center  = "engineering"
      product      = "checkout"
    }
  }
}

resource "dynatrace_openpipeline_v2_logs_pipelines" "team" {
  for_each = local.teams

  custom_id    = "pipeline_${each.key}_logs"
  display_name = each.value.display_name

  cost_allocation {
    processors {
      processor {
        id          = "processor_cost_center_${each.key}"
        description = "Assign cost center for ${each.key}"
        enabled     = true
        matcher     = "true"
        type        = "costAllocation"

        cost_allocation {
          value {
            type     = "constant"
            constant = each.value.cost_center
          }
        }
      }
    }
  }

  product_allocation {
    processors {
      processor {
        id          = "processor_product_${each.key}"
        description = "Assign product for ${each.key}"
        enabled     = true
        matcher     = "true"
        type        = "productAllocation"

        product_allocation {
          value {
            type     = "constant"
            constant = each.value.product
          }
        }
      }
    }
  }
}

# Wrap the team pipelines in a single group so they can be managed together
# and share the same stage configuration.
resource "dynatrace_openpipeline_v2_logs_pipelinegroups" "teams" {
  display_name = "Team log pipelines"

  member_pipelines = [
    for pipeline in dynatrace_openpipeline_v2_logs_pipelines.team : pipeline.id
  ]

  member_stages {
    type = "includeAll"
  }
}

# Route incoming logs to the matching team pipeline by Kubernetes namespace.
resource "dynatrace_openpipeline_v2_logs_routing" "teams" {
  routing_entries {
    dynamic "routing_entry" {
      for_each = local.teams

      content {
        description   = "Route ${routing_entry.value.namespace} namespace logs"
        enabled       = true
        matcher       = "matchesValue(k8s.namespace.name, \"${routing_entry.value.namespace}\")"
        pipeline_type = "custom"
        pipeline_id   = dynatrace_openpipeline_v2_logs_pipelines.team[routing_entry.key].id
      }
    }
  }
}
