resource "dynatrace_slo_v2" "this" {
  name               = var.name
  enabled            = var.enabled
  evaluation_type    = var.evaluation_type
  evaluation_window  = var.evaluation_window
  filter             = var.filter
  metric_expression  = var.metric_expression
  metric_name        = var.metric_name
  target_success     = var.target_success
  target_warning     = var.target_warning
  custom_description = var.custom_description

  # Provider schema requires this block (min 1).
  error_budget_burn_rate {
    burn_rate_visualization_enabled = try(var.error_budget_burn_rate.burn_rate_visualization_enabled, true)
    fast_burn_threshold             = try(var.error_budget_burn_rate.fast_burn_threshold, null)
  }
}
