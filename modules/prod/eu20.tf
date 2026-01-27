module checkout_mz {
  source = "../../templates/management_zone"
  app_env = "PRD"
  app_id = "123"
  app_name = "Checkout 2"
}

module availability_slo {
  source = "../../templates/slo_v2"
  name              = "CheckoutService - Availability"
  evaluation_window = "-7d"
  target_success    = 99.9
  target_warning    = 99.95
  filter = "type(service)"
  # Example from Dynatrace docs (service-level availability):
  metric_expression = "(100)*(builtin:service.errors.server.successCount:splitBy())/(builtin:service.requestCount.server:splitBy())"
  error_budget_burn_rate = {
    burn_rate_visualization_enabled = true
    fast_burn_threshold             = 10
  }
}

module metric_event {
  source = "../../templates/metric_event"
  summary = "CheckoutService error metric event"

  event_template = {
    title       = "CheckoutService: errors elevated"
    description = "Raised when service errors exceed the configured threshold."
    event_type  = "CUSTOM_ALERT"
    davis_merge = true
    metadatas   = {
      service = "CheckoutService"
      team    = "checkout"
    }
  }

  # NOTE: these values are examples. Use Dynatrace UI to pick the correct metric selector,
  # aggregation and model properties for your case.
  query_definition = {
    type        = "METRIC_SELECTOR"
    aggregation = "AVG"
    # Typically you'd filter to a specific SERVICE entity dimension; adjust as needed.
    metric_selector = "builtin:service.errors.server.count:splitBy():avg"
    query_offset    = 0
  }

  model_properties = {
    # The type/alert_condition values are provider-specific enumerations; adjust based on what you use in UI/export.
    type               = "STATIC_THRESHOLD"
    alert_condition    = "ABOVE"
    samples            = 5
    violating_samples  = 3
    dealerting_samples = 5
    threshold          = 1
    tolerance          = 0
  }
}

module custom_service_java {
  source = "../../templates/custom_service"
  name           = "CheckoutService - Custom Service"
  technology     = "java"
  rules = [
    {
      class = { name = "com.example.checkout.*", match = "STARTS_WITH" }
      annotations = ["prefix-match"]
      methods = [
        { name = "placeOrder", visibility = "PUBLIC" }
      ]
    }
  ]
}