locals {
  cost_allocation = {
    costcenters = {
      endpoint = "/v1/accounts/${var.dynatrace_account_uuid}/settings/costcenters"
      payload = jsonencode({
        values = [for value in sort(tolist(var.cost_centers)) : { key = value }]
      })
    }
    products = {
      endpoint = "/v1/accounts/${var.dynatrace_account_uuid}/settings/products"
      payload = jsonencode({
        values = [for value in sort(tolist(var.cost_products)) : { key = value }]
      })
    }
  }
}

resource "terraform_data" "cost_allocation" {
  for_each = local.cost_allocation

  triggers_replace = {
    endpoint     = each.value.endpoint
    payload_hash = sha256(each.value.payload)
  }

  provisioner "local-exec" {
    environment = {
      DT_API_BASE      = var.dynatrace_api_base
      DT_ACCOUNT_UUID  = var.dynatrace_account_uuid
      DT_CLIENT_ID     = var.dynatrace_oauth_client_id
      DT_CLIENT_SECRET = nonsensitive(var.dynatrace_oauth_client_secret)
      DT_RESOURCE      = "urn:dtaccount:${var.dynatrace_account_uuid}"
      DT_SCOPES        = "account-uac-write"
      DT_ENDPOINT      = each.value.endpoint
      DT_VALUES_JSON   = each.value.payload
    }

    command = "${path.module}/scripts/apply-cost-allocation.sh"
  }
}
