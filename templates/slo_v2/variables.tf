variable "name" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "evaluation_type" {
  type        = string
  default     = "AGGREGATE"
  description = "Currently Dynatrace supports AGGREGATE."
}

variable "evaluation_window" {
  type        = string
  default     = "-1h"
  description = "Timeframe, e.g. -1h, -1w, or '-2d to now'."
}

variable "filter" {
  type = string
  description = <<EOT
Entity selector for scope, e.g. type("SERVICE"),entityName.equals("CheckoutService").
EOT
}


variable "metric_expression" {
  type = string
}

variable "metric_name" {
  type    = string
  default = null
}

variable "target_success" {
  type = number
}

variable "target_warning" {
  type = number
}

variable "custom_description" {
  type    = string
  default = null
}

variable "error_budget_burn_rate" {
  description = "Error budget burn rate config. The block is required by the provider schema; fast_burn_threshold is optional."
  type = object({
    burn_rate_visualization_enabled = optional(bool, true)
    fast_burn_threshold             = optional(number)
  })

  # Provider schema requires at least one error_budget_burn_rate block.
  # We default to visualization enabled, and omit fast_burn_threshold unless explicitly set.
  default = {
    burn_rate_visualization_enabled = true
  }
}
