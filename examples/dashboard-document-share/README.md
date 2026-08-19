# Dashboard Document + Direct Share

Sample Terraform configuration that creates a Dynatrace platform dashboard (a *document*) and shares it with specific users — identified by **email address**, not UUID. Pass a single email to share with exactly one user.

It creates:

- **A user lookup** (`data.dynatrace_iam_user`, one per email) that resolves each address to the user's account UUID (`uid`). This is what lets you keep emails in your `.tfvars` instead of opaque UUIDs.
- **A dashboard document** (`dynatrace_document`) with `type = "dashboard"` and the tile/layout JSON in [`dashboard.json`](dashboard.json). It is created with `private = true`, so it is not readable by everybody in the environment.
- **A direct share** (`dynatrace_direct_shares`) with one `recipient` block of `type = "user"` per resolved address, granting `read` (or `read-write`) access.

Both the document and the share are required: the document alone is only visible to its owner, and the share is what grants the listed users access. If you leave `private = false`, everybody in the environment can read the dashboard and the share becomes meaningless.

```hcl
data "dynatrace_iam_user" "recipients" {
  for_each = var.share_with_user_emails

  email = each.value
}

resource "dynatrace_direct_shares" "cpu_overview" {
  document_id = dynatrace_document.cpu_overview.id
  access      = var.share_access

  recipients {
    dynamic "recipient" {
      for_each = data.dynatrace_iam_user.recipients

      content {
        id   = recipient.value.uid
        type = "user"
      }
    }
  }
}
```

`share_with_user_emails` is a set, so the same config covers one user and several without changing shape. Adding or removing an address updates the existing share in place — the document and its URL are untouched.

## Usage

```sh
# Environment credentials - document + direct share APIs
export DYNATRACE_ENV_URL="https://<your-environment>.apps.dynatrace.com"
export DYNATRACE_API_TOKEN="dt0c01.XXXXXXXX.YYYYYYYY"

# Account credentials - required for the dynatrace_iam_user lookup
export DYNATRACE_ACCOUNT_ID="urn:dtaccount:<account-uuid>"
export DYNATRACE_CLIENT_ID="dt0s02.XXXXXXXX"
export DYNATRACE_CLIENT_SECRET="dt0s02.XXXXXXXX.YYYYYYYY"

terraform init

# One user
terraform apply -var 'share_with_user_emails=["user@example.com"]'

# Several
terraform apply -var 'share_with_user_emails=["alice@example.com","bob@example.com"]'
```

The `DT_`-prefixed names (`DT_ACCOUNT_ID`, `DT_CLIENT_ID`, `DT_CLIENT_SECRET`) work as aliases.

### Required permissions

| Credential | Needs |
|------------|-------|
| Environment token | `document:documents:read`, `document:documents:write`, `document:direct-shares:read`, `document:direct-shares:write` |
| Account OAuth client | `account-idm-read` (to resolve emails to UUIDs) |

Without the account OAuth client the plan fails on the `dynatrace_iam_user` data source, before anything is created.

### Lookup behaviour

The lookups run at plan time and fail if any email matches no user — so a typo or an unprovisioned user surfaces immediately rather than as a share pointing at nothing:

```
Error: API request HTTP GET .../iam/v1/accounts/<uuid>/users/typo@example.com
failed with status code 404: {"message":"User typo@example.com not found."}
```

The `recipient_uids` output maps each email to its resolved UUID, which is worth checking after the first apply.

On non-production environments (sprint/dev), the provider derives the matching IAM endpoint and SSO token URL from `DYNATRACE_ENV_URL` automatically. Override with `iam_endpoint_url` / `iam_token_url` in the provider block only if you need to.

### The recipient cannot be the document owner

The document is owned by whichever identity the Terraform credentials belong to. Sharing it back to that same user is rejected:

```
Error: API request HTTP POST .../platform/document/v1/direct-shares failed with
status code 400: {"message":"Adding the document's owner to the recipients of the
document's share is not allowed."}
```

This bites when the token owner is also listed in `share_with_user_emails`. The owner already has full access — nothing to grant. Note that the document is still created before the share fails, so a re-apply with a corrected list creates only the share.

## Variables

| Name | Default | Description |
|------|---------|-------------|
| `dashboard_name` | `Host CPU overview (Terraform)` | Display name of the document |
| `share_with_user_emails` | *(required)* | Set of recipient emails; must be non-empty and exclude the document owner |
| `share_access` | `read` | `read` or `read-write` |

## Sharing with a group

To share with everyone in a Dynatrace group instead, look the group up by name and emit `type = "group"` recipients:

```hcl
data "dynatrace_iam_group" "viewers" {
  name = "Dashboard viewers"
}

recipients {
  recipient {
    id   = data.dynatrace_iam_group.viewers.id
    type = "group"
  }
}
```

User and group recipients can be mixed in the same `recipients` block.

> **Note:** the dashboard content is fully managed by Terraform. Edits made in the Dynatrace UI are overwritten on the next `terraform apply`. To pull UI changes back, export the dashboard JSON and update `dashboard.json`.
