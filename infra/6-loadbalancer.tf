# health check for the web server GCP
# resource "google_compute_health_check" "health_checks" {
#     name               = "http-basic-check"
#     check_interval_sec = 1
#     timeout_sec        = 1
#     healthy_threshold  = 1
#     unhealthy_threshold = 10
#     http_health_check {
#         port = 80
#     }
# }


# internal load balancer for the web server GCP
# resource "google_compute_backend_service" "webserver-lb" {
#   name        = "webserver-lb-backend"
#   protocol    = "HTTP"
#   timeout_sec = 10

#   health_checks = [google_compute_health_check.http.name]

#   backend {
#     group = google_compute_instance.lbtestnode[0].self_link
#   }

#   backend {
#     group = google_compute_instance.lbtestnode[1].self_link
#   }

#   backend {
#     group = google_compute_instance.lbtestnode[2].self_link
#   }
# }