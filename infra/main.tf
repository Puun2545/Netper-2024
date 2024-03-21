# GCP Auto Scaling group
#   resource "google_compute_autoscaler" "webserver-lb-autoscaler" {
#     name               = "webserver-lb-autoscaler"
#     target            = google_compute_backend_service.webserver-lb.id
#     autoscaling_policy {
#       max_replicas = 5
#       min_replicas = 2
#       cool_down_period_sec = 60
#       cpu_utilization {
#         target = 0.8
#       }
#     }
#   }
#
# resource "google_compute_forwarding_rule" "webserver" {
#   name       = "webserver-forwarding-rule"
#   target     = google_compute_backend_service.webserver.id
#   port_range = "80"
#   load_balancing_scheme = "INTERNAL"
#   network = google_compute_network.main.name
# }
#

# Path: infra/3-network.tf