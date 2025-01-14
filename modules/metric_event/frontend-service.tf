
module "frontend-service-metric-event" {
    source = "../../templates/metric_event"
    config_name = "High disk usage"
    event_description = "High disk usage on host {dt.entity.host}"
    event_title = "High disk usage!"
}