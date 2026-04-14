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
