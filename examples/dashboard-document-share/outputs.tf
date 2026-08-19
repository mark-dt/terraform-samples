output "document_id" {
  description = "ID of the dashboard document."
  value       = dynatrace_document.cpu_overview.id
}

output "document_owner" {
  description = "User ID that owns the document (the identity behind the Terraform credentials)."
  value       = dynatrace_document.cpu_overview.owner
}

output "recipient_uids" {
  description = "Email to resolved UUID, for verifying the right users were matched."
  value       = { for email, user in data.dynatrace_iam_user.recipients : email => user.uid }
}

output "direct_share_id" {
  description = "ID of the direct share granting access to the recipients."
  value       = dynatrace_direct_shares.cpu_overview.id
}

output "dashboard_path" {
  description = "Append this to your environment URL to open the dashboard."
  value       = "/ui/apps/dynatrace.dashboards/dashboard/${dynatrace_document.cpu_overview.id}"
}
