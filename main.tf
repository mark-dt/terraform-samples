check "cost_allocation_inputs" {
  assert {
    condition = !var.enable_cost_allocation || (
      var.dynatrace_account_uuid != null &&
      var.dynatrace_oauth_client_id != null &&
      var.dynatrace_oauth_client_secret != null &&
      length(var.cost_centers) > 0 &&
      length(var.cost_products) > 0
    )
    error_message = "When enable_cost_allocation is true, set dynatrace_account_uuid, dynatrace_oauth_client_id, dynatrace_oauth_client_secret, cost_centers, and cost_products."
  }
}

module "cost_allocation" {
  count = var.enable_cost_allocation ? 1 : 0

  source = "./tf-cost-allocation"

  dynatrace_api_base            = var.dynatrace_api_base
  dynatrace_account_uuid        = var.dynatrace_account_uuid
  dynatrace_oauth_client_id     = var.dynatrace_oauth_client_id
  dynatrace_oauth_client_secret = var.dynatrace_oauth_client_secret
  cost_centers                  = var.cost_centers
  cost_products                 = var.cost_products
}

locals {
  service_defaults = {
    evaluation_window           = "-7d"
    availability_target_success = 99.9
    availability_target_warning = 99.95
    performance_target_success  = 95
    performance_target_warning  = 97
    performance_threshold_us    = 1000000 # 1s in microseconds
  }

  services_map = {
    for svc in local.services : svc.name => merge(local.service_defaults, svc)
  }
}

module "availability_slo" {
  for_each = local.services_map
  source   = "./templates/slo_v2"

  name              = "${each.key} - Availability"
  evaluation_window = each.value.evaluation_window
  filter            = "type(\"SERVICE\"),entityName.equals(\"${each.key}\")"
  target_success    = each.value.availability_target_success
  target_warning    = each.value.availability_target_warning
  metric_expression = "(100)*(builtin:service.errors.server.successCount:splitBy())/(builtin:service.requestCount.server:splitBy())"

  error_budget_burn_rate = {
    burn_rate_visualization_enabled = true
    fast_burn_threshold             = 10
  }
}

module "performance_slo" {
  for_each = local.services_map
  source   = "./templates/slo_v2"

  name              = "${each.key} - Performance"
  evaluation_window = each.value.evaluation_window
  filter            = "type(\"SERVICE\"),entityName.equals(\"${each.key}\")"
  target_success    = each.value.performance_target_success
  target_warning    = each.value.performance_target_warning
  metric_expression = "((builtin:service.response.time:avg:partition(\"latency\",value(\"good\",lt(${each.value.performance_threshold_us}))):splitBy():count:default(0))/(builtin:service.response.time:avg:splitBy():count)*(100)):default(100,always)"

  error_budget_burn_rate = {
    burn_rate_visualization_enabled = true
    fast_burn_threshold             = 10
  }
}
