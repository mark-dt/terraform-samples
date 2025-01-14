variable "DYNATRACE_ENV_URL" {
  description = "The URL for the Dynatrace environment (e.g., https://<your-environment>.live.dynatrace.com/api)"
  type        = string
  default     = "123"
}

variable "DYNATRACE_API_TOKEN" {
  description = "The API token for Dynatrace"
  type        = string
  sensitive   = true
  default     = "123"
}

variable "management_zone_name" {
  description = "Name of the management zone to create"
  type        = string
  default     = "Test Management Zone - NEW 2" # Replace with a dynamic value if needed
}
