# Sample: create a Dynatrace platform dashboard as a document and share it with
# specific users, identified by email address.
#
# Three pieces are involved:
#   data.dynatrace_iam_user - resolves each email to the user's account UUID
#   dynatrace_document      - the dashboard itself (JSON content in dashboard.json)
#   dynatrace_direct_shares - the direct share granting access to those users
#
# The document is created with private = true so it is NOT readable by everybody
# in the environment. The only access besides the owner's is the direct share
# below. Pass a single email in share_with_user_emails to share with exactly one
# user; the same config scales to a handful without changing shape.

# Looks each user up in Account Management by email and exposes the UUID as
# `uid`. This is an account-level API call, so the provider needs IAM
# credentials (client_id / client_secret / account_id) on top of the
# environment token - see README. Fails at plan time if an email matches no user.
data "dynatrace_iam_user" "recipients" {
  for_each = var.share_with_user_emails

  email = each.value
}

resource "dynatrace_document" "cpu_overview" {
  name = var.dashboard_name
  type = "dashboard"

  # Keep the document out of the environment-wide "shared with everyone" scope.
  # Without this, the direct share is pointless - everyone could read it anyway.
  private = true

  content = file("${path.module}/dashboard.json")
}

resource "dynatrace_direct_shares" "cpu_overview" {
  document_id = dynatrace_document.cpu_overview.id
  access      = var.share_access

  recipients {
    # One recipient block per resolved user. Switch type to "group" and feed in
    # group UUIDs (see data.dynatrace_iam_group) to share with a whole group.
    dynamic "recipient" {
      for_each = data.dynatrace_iam_user.recipients

      content {
        id   = recipient.value.uid
        type = "user"
      }
    }
  }
}
