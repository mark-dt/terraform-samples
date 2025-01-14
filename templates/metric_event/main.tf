resource "dynatrace_metric_events" "metric_event" {
  enabled                    = true
  event_entity_dimension_key = "dt.entity.host"
  summary                    = var.config_name
  event_template {
    description   = var.event_description
    davis_merge = false
    event_type    = "RESOURCE"
    title         = var.event_title
  }
  model_properties {
    type               = "STATIC_THRESHOLD"
    alert_condition    = "ABOVE"
    alert_on_no_data   = false
    dealerting_samples = 5
    samples            = 5
    threshold          = 85
    violating_samples  = 3
  }
  query_definition {
    type        = "METRIC_KEY"
    aggregation = "AVG"
    metric_key  = "builtin:host.disk.usedPct"
    dimension_filter {
      filter {
        dimension_key   = "dt.entity.host"
        dimension_value = "HOST-9DDF1200A29EFAC9"
      }
      filter {
        dimension_key   = "dt.entity.disk.name"
        dimension_value = "/local"
      }
      filter {
        dimension_key   = "dt.entity.disk"
        dimension_value = "DISK-3DC3FC42FBB07595"
      }
    }
    entity_filter {
      dimension_key = "dt.entity.host"
      conditions {
        condition {
          type     = "NAME"
          operator = "EQUALS"
          value    = "HOST-80FF882B3215BF1A"
        }
        condition {
          type     = "ENTITY_ID"
          operator = "EQUALS"
          value    = "HOST-32D0DB4904B28FB3"
        }
        condition {
          type     = "MANAGEMENT_ZONE"
          operator = "EQUALS"
          value    = "-189204438944455158"
        }
        condition {
          type     = "HOST_GROUP_NAME"
          operator = "EQUALS"
          value    = "HOST-42FDD00356069724"
        }
      }
    }
  }
}