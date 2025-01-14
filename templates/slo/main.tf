resource "dynatrace_slo_v2" "Service_Level_Objective_Terraform_Test" {
  name              = var.sloConfigName
  enabled           = true
  evaluation_type   = "AGGREGATE"
  evaluation_window = "-1w"
  filter            =<<-EOT
    type("SERVICE"), tag("environment:${var.releaseStage}")
    
  EOT
  metric_expression =<<-EOT
    ((builtin:service.response.time:avg:partition("latency",value("good",lt(1000))):splitBy():count:default(1))/(builtin:service.response.time:avg:splitBy():count)*(100))
  EOT
  metric_name       = "${var.sloMetricName}_${var.releaseStage}_response_time"
  target_success    = 98
  target_warning    = 99
  error_budget_burn_rate {
    burn_rate_visualization_enabled = true
    fast_burn_threshold             = 10
  }
}