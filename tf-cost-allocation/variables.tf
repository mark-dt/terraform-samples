variable "dynatrace_api_base" {
  type    = string
  default = "https://api.dynatrace.com"

  validation {
    condition     = can(regex("^https://", var.dynatrace_api_base))
    error_message = "dynatrace_api_base must start with https://"
  }
}

variable "dynatrace_account_uuid" {
  type = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.dynatrace_account_uuid))
    error_message = "dynatrace_account_uuid must be a UUID."
  }
}

variable "dynatrace_oauth_client_id" {
  type = string
}

variable "dynatrace_oauth_client_secret" {
  type      = string
  sensitive = true
}

variable "cost_centers" {
  type = set(string)

  validation {
    condition     = length(var.cost_centers) > 0
    error_message = "cost_centers must contain at least one value."
  }
}

variable "cost_products" {
  type = set(string)

  validation {
    condition     = length(var.cost_products) > 0
    error_message = "cost_products must contain at least one value."
  }
}
