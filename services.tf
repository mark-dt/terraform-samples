# Define your services here. Each entry creates one availability SLO
# and one performance SLO.
#
# Override any defaults per service as needed (see variable definition in variables.tf).

locals {
  services = [
    { name = "CheckoutService" },
    { name = "PaymentService" },
    {
      name                        = "OrderService"
      availability_target_success = 99.95
      availability_target_warning = 99.98
      performance_threshold_us    = 500000 # 500ms
    },
  ]
}
