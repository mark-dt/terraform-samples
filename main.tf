provider "dynatrace" {
  alias        = "nonprod"
  dt_env_url   = var.DYNATRACE_ENV_URL
  dt_api_token = var.DYNATRACE_API_TOKEN
}

module "prod_eu20" {
  source = "./modules/prod"
}