variable "DYNATRACE_ENV_URL" {
  description = "The URL for the Dynatrace environment (e.g., https://<your-environment>.live.dynatrace.com/api)"
  type        = string
  default     = "123"
}

variable "DYNATRACE_API_TOKEN" {
  description = "The API token for Dynatrace"
  type        = string
  sensitive   = true
  default     = "123"
}

variable "management_zone_name" {
  description = "Name of the management zone to create"
  type        = string
  default     = "Test Management Zone - NEW 2" # Replace with a dynamic value if needed
}

variable "enable_cost_allocation" {
  description = "When true, apply Dynatrace account cost center and product allocations."
  type        = bool
  default     = false
}

variable "dynatrace_api_base" {
  description = "Dynatrace account API base URL used for cost allocation updates."
  type        = string
  default     = "https://api.dynatrace.com"

  validation {
    condition     = can(regex("^https://", var.dynatrace_api_base))
    error_message = "dynatrace_api_base must start with https://"
  }
}

variable "dynatrace_account_uuid" {
  description = "Dynatrace account UUID for account-level cost allocation settings."
  type        = string
  default     = null
}

variable "dynatrace_oauth_client_id" {
  description = "OAuth client ID with account-uac-write scope for cost allocation updates."
  type        = string
  default     = null
}

variable "dynatrace_oauth_client_secret" {
  description = "OAuth client secret with account-uac-write scope for cost allocation updates."
  type        = string
  sensitive   = true
  default     = null
}

variable "cost_centers" {
  description = "Cost center keys to upsert into Dynatrace account cost allocation settings."
  type        = set(string)
  default     = []
}

variable "cost_products" {
  description = "Product keys to upsert into Dynatrace account cost allocation settings."
  type        = set(string)
  default     = []
}
