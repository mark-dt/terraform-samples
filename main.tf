provider "dynatrace" {
  alias        = "nonprod"
  dt_env_url   = var.DYNATRACE_ENV_URL
  dt_api_token = var.DYNATRACE_API_TOKEN
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