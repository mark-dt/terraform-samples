resource "dynatrace_metric_events" "this" {
  enabled                    = var.enabled
  summary                    = var.summary
  event_entity_dimension_key = var.event_entity_dimension_key

  event_template {
    title       = var.event_template.title
    description = try(var.event_template.description, null)
    event_type  = var.event_template.event_type
    davis_merge = try(var.event_template.davis_merge, false)

    # Provider schema uses "metadata" blocks (Block Set)
    dynamic "metadata" {
      for_each = try(var.event_template.metadatas, {})
      content {
        metadata_key   = metadata.key
        metadata_value = metadata.value
      }
    }
  }

  model_properties {
    type               = var.model_properties.type
    alert_condition    = var.model_properties.alert_condition
    alert_on_no_data   = try(var.model_properties.alert_on_no_data, false)
    samples            = var.model_properties.samples
    violating_samples  = var.model_properties.violating_samples
    dealerting_samples = var.model_properties.dealerting_samples
    signal_fluctuation = try(var.model_properties.signal_fluctuation, null)
    threshold          = try(var.model_properties.threshold, null)
    tolerance          = try(var.model_properties.tolerance, null)
  }

  query_definition {
    type            = var.query_definition.type
    aggregation     = (var.query_definition.type == "METRIC_SELECTOR" ? null : try(var.query_definition.aggregation, null))
    metric_key      = try(var.query_definition.metric_key, null)
    metric_selector = try(var.query_definition.metric_selector, null)
    query_offset    = try(var.query_definition.query_offset, null)
    management_zone = try(var.query_definition.management_zone, null)

    dynamic "dimension_filter" {
      for_each = length(try(var.query_definition.dimension_filter, [])) > 0 ? [1] : []
      content {
        # Provider schema uses "filter" blocks (Min: 1) inside dimension_filter
        dynamic "filter" {
          for_each = try(var.query_definition.dimension_filter, [])
          content {
            dimension_key   = filter.value.dimension_key
            dimension_value = filter.value.dimension_value
            operator        = filter.value.operator
          }
        }
      }
    }

    dynamic "entity_filter" {
      for_each = try(var.query_definition.entity_filter, null) == null ? [] : [var.query_definition.entity_filter]
      content {
        dimension_key = entity_filter.value.dimension_key
        conditions {
          # Provider schema uses "condition" blocks (Min: 1) inside conditions
          dynamic "condition" {
            for_each = entity_filter.value.conditions
            content {
              type     = condition.value.type
              operator = condition.value.operator
              value    = condition.value.value
            }
          }
        }
      }
    }
  }
}
