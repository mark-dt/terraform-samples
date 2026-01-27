variable "enabled" {
  type    = bool
  default = true
}

variable "summary" {
  type = string
}

variable "event_entity_dimension_key" {
  type    = string
  default = null
}

variable "event_template" {
  type = object({
    title       = string
    description = optional(string)
    event_type  = string
    davis_merge = optional(bool, false)
    metadatas   = optional(map(string), {})
  })
}

variable "model_properties" {
  type = object({
    type               = string
    alert_condition    = string
    alert_on_no_data   = optional(bool, false)
    samples            = number
    violating_samples  = number
    dealerting_samples = number
    signal_fluctuation = optional(number)
    threshold          = optional(number)
    tolerance          = optional(number)
  })
}

variable "query_definition" {
  type = object({
    type            = string
    aggregation     = optional(string)
    metric_key      = optional(string)
    metric_selector = optional(string)
    query_offset    = optional(number)
    management_zone = optional(string)

    dimension_filter = optional(list(object({
      dimension_key   = string
      dimension_value = string
      operator        = string
    })), [])

    entity_filter = optional(object({
      dimension_key = string
      conditions = list(object({
        type     = string
        operator = string
        value    = string
      }))
    }))
  })
}
