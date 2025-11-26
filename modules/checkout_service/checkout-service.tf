module checkout-mz {
    source = "../../templates/management_zone"
    app_env = "PRD"
    app_id = "123"
    app_name = "Checkout"
}

module checkout-service-ownership {
    source = "../../templates/ownership"
    ownership_config_name = "checkout_service"
    ownership_contact = "checkout_service@email.com"
}
