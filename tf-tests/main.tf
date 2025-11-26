provider "dynatrace" {
  alias        = "nonprod"
  dt_env_url   = var.DYNATRACE_ENV_URL
  dt_api_token = var.DYNATRACE_API_TOKEN
}
resource "dynatrace_opentelemetry_metrics" "otel-test-metrics" {
  additional_attributes_to_dimension_enabled = true
  meter_name_to_dimension_enabled            = true
  scope                                      = "environment"
  additional_attributes {
    additional_attribute {
      enabled       = true
      attribute_key = "dt.entity.host_group"
    }
    additional_attribute {
      enabled       = true
      attribute_key = "dt.kubernetes.workload.kind"
    }
    additional_attribute {
      enabled       = true
      attribute_key = "dt.kubernetes.workload.name"
    }
    additional_attribute {
      enabled       = true
      attribute_key = "dt.kubernetes.cluster.id"
    }
  }
  to_drop_attributes {
    to_drop_attribute {
      enabled       = true
      attribute_key = "terraform.test.drop"
    }
  }
}
resource "dynatrace_opentelemetry_metrics" "otel-test-metrics-2" {
  additional_attributes_to_dimension_enabled = true
  meter_name_to_dimension_enabled            = true
  scope                                      = "environment"
  additional_attributes {
    additional_attribute {
      enabled       = true
      attribute_key = "dt.entity.host_group"
    }
    additional_attribute {
      enabled       = true
      attribute_key = "dt.kubernetes.workload.kind"
    }
    additional_attribute {
      enabled       = true
      attribute_key = "dt.kubernetes.workload.name"
    }
    additional_attribute {
      enabled       = true
      attribute_key = "dt.kubernetes.cluster.id"
    }
  }
  to_drop_attributes {
    to_drop_attribute {
      enabled       = true
      attribute_key = "terraform.test.drop"
    }
  }
}