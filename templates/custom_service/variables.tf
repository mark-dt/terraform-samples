variable "enabled" {
  type    = bool
  default = true
}

variable "name" {
  type = string
}

variable "technology" {
  type = string
}

variable "process_groups" {
  description = "List of process group IDs to scope the custom service to. Optional."
  type        = list(string)
  default     = null
  nullable    = true
}

variable "queue_entry_point" {
  type    = bool
  default = false
}

variable "queue_entry_point_type" {
  type    = string
  default = null
}

variable "unknowns" {
  type    = string
  default = null
}

variable "rules" {
  type = list(object({
    enabled     = optional(bool, true)
    annotations = optional(list(string), [])

    class = object({
      name  = string
      match = string
    })

    file = optional(object({
      name  = string
      match = string
    }))

    methods = optional(list(object({
      name       = string
      arguments  = optional(list(string), [])
      visibility = optional(string)
      returns    = optional(string)
      modifiers  = optional(list(string), [])
      id         = optional(string)
      unknowns   = optional(string)
    })), [])

    unknowns = optional(string)
  }))
  default = []
}
