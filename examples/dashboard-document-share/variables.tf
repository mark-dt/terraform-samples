variable "dashboard_name" {
  description = "Display name of the dashboard document in Dynatrace."
  type        = string
  default     = "Host CPU overview (Terraform)"
}

variable "share_with_user_emails" {
  description = <<-EOT
    Email addresses of the Dynatrace users the dashboard is shared with.
    Pass a single-element set to share with exactly one user. Terraform resolves
    each address to the user's UUID via the dynatrace_iam_user data source, so
    account-level IAM credentials are required (see README).

    The document owner (the identity behind the Terraform credentials) must NOT
    be listed - the API rejects sharing a document back to its own owner.
  EOT
  type        = set(string)

  validation {
    condition     = length(var.share_with_user_emails) > 0
    error_message = "share_with_user_emails must contain at least one email address."
  }

  validation {
    condition = alltrue([
      for e in var.share_with_user_emails :
      can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", e))
    ])
    error_message = "Every entry in share_with_user_emails must be a valid email address."
  }
}

variable "share_access" {
  description = "Access level granted to the recipients: read or read-write."
  type        = string
  default     = "read"

  validation {
    condition     = contains(["read", "read-write"], var.share_access)
    error_message = "share_access must be either \"read\" or \"read-write\"."
  }
}
