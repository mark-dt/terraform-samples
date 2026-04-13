provider "dynatrace" {
  alias        = "nonprod"
  dt_env_url   = var.DYNATRACE_ENV_URL
  dt_api_token = var.DYNATRACE_API_TOKEN
}

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

module "management_zone" {
  source = "./modules/management_zone"
}

module "web_application" {
  source = "./modules/web_application"
}

module "ownership" {
  source = "./modules/ownership"
}

module "metric_event" {
  source = "./modules/metric_event"
}

module "checkout_service" {
  source = "./modules/checkout_service"
}
