
resource "dynatrace_alerting" "alerting_profile" {
  name            = join("_", [upper(var.app_env), "GE", var.app_id, var.app_name, "Alertingprofile"])
  // management_zone = dynatrace_management_zone_v2.management_zone.id
  rules {
    rule {
      delay_in_minutes = 0
      include_mode     = "NONE"
      severity_level   = "MONITORING_UNAVAILABLE"
    }

    rule {
      delay_in_minutes = 0
      include_mode     = "NONE"
      severity_level   = "AVAILABILITY"
    }
    rule {
      delay_in_minutes = 0
      include_mode     = "NONE"
      severity_level   = "ERRORS"
    }
  }
}

