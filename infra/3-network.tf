# Purpose: Create a network and a default route to the internet.

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"

  disable_on_destroy = false
}

# vpc network
resource "google_compute_network" "main" {
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true

  depends_on = [google_project_service.compute]
}

# default route to the internet
resource "google_compute_route" "my_route_internet" {
  name             = "default-internet-gateway"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.main.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
  description      = "Default route to the Internet."
}

# private and public subnetwork
resource "google_compute_subnetwork" "private" {
    count = 3
    name                     = "private${count.index + 1}"
    region                   = local.region
    ip_cidr_range            = "10.0.10${count.index + 1}.0/24"
    stack_type               = "IPV4_ONLY"
    network                  = google_compute_network.main.id
    private_ip_google_access = true
}

resource "google_compute_subnetwork" "public" {
  name          = "public"
  region        = local.region
  ip_cidr_range = "10.0.10.0/24"
  stack_type    = "IPV4_ONLY"
  network       = google_compute_network.main.id
}

# router
resource "google_compute_router" "router" {
  name    = "router"
  region  = local.region
  network = google_compute_network.main.id
}

# router NAT
resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}

resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  region = local.region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option = "AUTO_ONLY"

  # Assign unique NAT IP addresses to each subnetwork
  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.private

    content {
      name                    = subnetwork.value.id
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}
