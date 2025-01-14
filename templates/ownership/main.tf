resource "dynatrace_ownership_config" "ownership_config" {
  ownership_identifiers {
    ownership_identifier {
      enabled = true
      key     = "dt.owner"
    }
    ownership_identifier {
      enabled = true
      key     = "owner"
    }
  }
}


resource "dynatrace_ownership_teams" "ownership_teams" {
  name       = var.ownership_config_name
  identifier = var.ownership_config_name
  contact_details {
    contact_detail {
      email            = var.ownership_contact
      integration_type = "EMAIL"
    }
  }
  responsibilities {
    development      = true
    infrastructure   = true
    line_of_business = false
    operations       = true
    security         = false
  }
}