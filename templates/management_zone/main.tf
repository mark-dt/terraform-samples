resource "dynatrace_management_zone_v2" "management_zone" {
  name        = join("_", [upper(var.app_env), var.app_id, var.app_name])
  description = "Dies ist eine mit terraform erzeugte Management Zone."

  rules {

    rule {
      type    = "ME"
      enabled = true
      attribute_rule {
        entity_type = "WEB_APPLICATION"
        attribute_conditions {
          condition {
            case_sensitive = true
            key            = "WEB_APPLICATION_NAME"
            operator       = "EQUALS"
            string_value   = join("_", [upper(var.app_env), var.app_id, var.app_name])
          }
        }
      }
    }


    rule {
      type    = "ME"
      enabled = "true"
      attribute_rule {
        entity_type           = "HOST"
        host_to_pgpropagation = true
        attribute_conditions {
          condition {
            key      = "HOST_TAGS"
            operator = "EQUALS"
            tag      = join(":", ["[AWS]environment", var.app_env])
          }

          condition {
            key      = "HOST_TAGS"
            operator = "EQUALS"
            tag      = join(":", ["[AWS]appid", var.app_id]) //[AWS]appid: APP-4366
          }
        }
      }
    }

    rule {
      type    = "ME"
      enabled = true
      attribute_rule {
        entity_type = "CLOUD_APPLICATION_NAMESPACE"
        attribute_conditions {
          condition {
            case_sensitive = false
            key            = "KUBERNETES_CLUSTER_NAME"
            operator       = "EQUALS"
            string_value   = join("_", [var.app_env, var.app_id, var.app_name])
          }
        }
      }
    }


    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(CONTAINER_GROUP_INSTANCE),tag(\"component:${var.app_name}\")"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(CONTAINER_GROUP),tag(\"component:${var.app_name}\")"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(CLOUD_APPLICATION_NAMESPACE),toRelationship.isCgiOfNamespace(type(CONTAINER_GROUP_INSTANCE),tag(\"component:${var.app_name}\"))"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(cloud_application),toRelationship.isCgiOfCa(type(CONTAINER_GROUP_INSTANCE),tag(\"component:${var.app_name}\"))"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(SERVICE),databaseName.exists(),toRelationship.calls(type(SERVICE),tag(\"component:${var.app_name}\"))"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(PROCESS_GROUP_INSTANCE),tag(\"component:${var.app_name}\")"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(KUBERNETES_CLUSTER),fromRelationships.isClusterOfCa(type(CLOUD_APPLICATION),toRelationships.isPgOfCa(type(PROCESS_GROUP),tag(\"component:${var.app_name}\")))"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(KUBERNETES_NODE),toRelationships.runsOn(type(CLOUD_APPLICATION_INSTANCE),toRelationships.isPgOfCai(type(PROCESS_GROUP),tag(\"component:${var.app_name}\")))"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(CLOUD_APPLICATION_INSTANCE),toRelationships.isPgOfCai(type(PROCESS_GROUP),tag(\"component:${var.app_name}\"))"

    }
    rule {

      type            = "SELECTOR"
      enabled         = true
      entity_selector = "type(KUBERNETES_SERVICE),fromRelationships.isKubernetesSvcOfCa(type(CLOUD_APPLICATION),toRelationships.isPgOfCa(type(PROCESS_GROUP),tag(\"component:${var.app_name}\")))"

    }

    rule {

      type    = "ME"
      enabled = true
      attribute_rule {
        entity_type = "HTTP_MONITOR"
        attribute_conditions {
          condition {
            key      = "HTTP_MONITOR_TAGS"
            operator = "EQUALS"
            tag      = "component:${var.app_name}"
          }
        }
      }

    }

    rule {

      type    = "ME"
      enabled = true
      attribute_rule {
        entity_type = "EXTERNAL_MONITOR"
        attribute_conditions {
          condition {
            key      = "EXTERNAL_MONITOR_TAGS"
            operator = "EQUALS"
            tag      = "component:${var.app_name}"
          }
        }

      }
    }

    rule {

      type    = "ME"
      enabled = true
      attribute_rule {
        entity_type = "BROWSER_MONITOR"
        attribute_conditions {
          condition {
            key      = "BROWSER_MONITOR_TAGS"
            operator = "EQUALS"
            tag      = "component:${var.app_name}"
          }
        }

      }
    }

    rule {

      type    = "ME"
      enabled = true
      attribute_rule {
        entity_type               = "PROCESS_GROUP"
        pg_to_host_propagation    = true
        pg_to_service_propagation = true
        attribute_conditions {
          condition {
            key      = "PROCESS_GROUP_TAGS"
            operator = "EQUALS"
            tag      = "component:${var.app_name}"
          }
        }
      }

    }
  }
}

