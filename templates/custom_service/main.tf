resource "dynatrace_custom_service" "this" {
  enabled                = var.enabled
  name                   = var.name
  technology             = var.technology
  process_groups         = var.process_groups
  queue_entry_point      = var.queue_entry_point
  queue_entry_point_type = var.queue_entry_point_type
  unknowns               = var.unknowns

  dynamic "rule" {
    for_each = var.rules
    content {
      enabled     = try(rule.value.enabled, true)
      annotations = try(rule.value.annotations, [])

      class {
        name  = rule.value.class.name
        match = rule.value.class.match
      }

      dynamic "file" {
        for_each = try(rule.value.file, null) == null ? [] : [rule.value.file]
        content {
          name  = file.value.name
          match = file.value.match
        }
      }

      # Provider schema uses "method" (Block List, Min: 1)
      dynamic "method" {
        for_each = try(rule.value.methods, [])
        content {
          name       = method.value.name
          arguments  = try(method.value.arguments, [])
          visibility = try(method.value.visibility, null)
          returns    = try(method.value.returns, null)
          modifiers  = try(method.value.modifiers, [])
          id         = try(method.value.id, null)
          unknowns   = try(method.value.unknowns, null)
        }
      }

      unknowns = try(rule.value.unknowns, null)
    }
  }
}
