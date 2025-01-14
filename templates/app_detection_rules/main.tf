resource "dynatrace_web_application" "EasyTrade" {
  name                                 = var.webApplicationName
  type                                 = "AUTO_INJECTED"
  cost_control_user_session_percentage = 100
  load_action_key_performance_metric   = "VISUALLY_COMPLETE"
  real_user_monitoring_enabled         = true
  xhr_action_key_performance_metric    = "VISUALLY_COMPLETE"
  custom_action_apdex_settings {
    frustrating_fallback_threshold = 12000
    frustrating_threshold          = 12000
    tolerated_fallback_threshold   = 3000
    tolerated_threshold            = 3000
  }
  load_action_apdex_settings {
    frustrating_fallback_threshold = 12000
    frustrating_threshold          = 12000
    tolerated_fallback_threshold   = 3000
    tolerated_threshold            = 3000
  }
  monitoring_settings {
    cache_control_header_optimizations   = true
    # cookie_placement_domain            = ""
    # correlation_header_inclusion_regex = ""
    # custom_configuration_properties    = ""
    # exclude_xhr_regex                  = ""
    fetch_requests                       = true
    injection_mode                       = "JAVASCRIPT_TAG"
    # library_file_location              = ""
    # monitoring_data_path               = ""
    # secure_cookie_attribute            = false
    # server_request_path_id             = ""
    xml_http_request                     = true
    advanced_javascript_tag_settings {
      # instrument_unsupported_ajax_frameworks = false
      max_action_name_length                   = 100
      max_errors_to_capture                    = 10
      # special_characters_to_escape           = ""
      # sync_beacon_firefox                    = false
      # sync_beacon_internet_explorer          = false
      additional_event_handlers {
        # blur                          = false
        # change                        = false
        # click                         = false
        max_dom_nodes                   = 5000
        # mouseup                       = false
        # to_string_method              = false
        # use_mouse_up_event_for_clicks = false
      }
      global_event_capture_settings {
        # additional_event_captured_as_user_input = ""
        change                                    = true
        click                                     = true
        doubleclick                               = true
        keydown                                   = true
        keyup                                     = true
        mousedown                                 = true
        mouseup                                   = true
        scroll                                    = true
        touch_end                                 = true
        touch_start                               = true
      }
    }
    content_capture {
      javascript_errors                 = true
      visually_complete_and_speed_index = true
      resource_timing_settings {
        instrumentation_delay      = 50
        # non_w3c_resource_timings = false
        w3c_resource_timings       = true
      }
      timeout_settings {
        temporary_action_limit         = 0
        temporary_action_total_timeout = 100
        # timed_action_support         = false
      }
      visually_complete_settings {
        # exclude_url_regex      = ""
        # ignored_mutations_list = ""
        inactivity_timeout       = 1000
        mutation_timeout         = 50
        threshold                = 50
      }
    }
    javascript_framework_support {
      # active_x_object = false
      # angular         = false
      # dojo            = false
      # extjs           = false
      # icefaces        = false
      # jquery          = false
      # moo_tools       = false
      # prototype       = false
    }
  }
  session_replay_config {
    enabled                       = var.sessionReplayEnabled
    cost_control_percentage       = var.sessionReplayPercentage
    enable_css_resource_capturing = true
  }
  user_action_naming_settings {
    ignore_case                      = true
    query_parameter_cleanups         = [ "cfid", "phpsessid", "__sid", "cftoken", "sid" ]
    split_user_actions_by_domain     = true
    # use_first_detected_load_action = false
  }
  waterfall_settings {
    resource_browser_caching_threshold            = 50
    resources_threshold                           = 100000
    slow_cnd_resources_threshold                  = 200000
    slow_first_party_resources_threshold          = 200000
    slow_third_party_resources_threshold          = 200000
    speed_index_visually_complete_ratio_threshold = 50
    uncompressed_resources_threshold              = 860
  }
  xhr_action_apdex_settings {
    frustrating_fallback_threshold = 12000
    frustrating_threshold          = 12000
    tolerated_fallback_threshold   = 3000
    tolerated_threshold            = 3000
  }
}

output "web_application_id" {
  value = dynatrace_web_application.EasyTrade.id
}

resource "dynatrace_application_detection_rule" "app_detection_rule" {
  application_identifier = dynatrace_web_application.EasyTrade.id
  filter_config {
    application_match_target = "DOMAIN"
    application_match_type   = "MATCHES"
    pattern                  = "easytrade-test"
  }
}
