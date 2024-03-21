# compute_instance
resource "google_compute_instance" "config_node" {
    count = 3
    name         = format("config-node-%d", count.index)
    machine_type = "e2-micro"
    zone         = "asia-southeast1-a"
    tags         = ["config-node", "config-node-${count.index + 1}"]
    
    boot_disk {
        initialize_params {
        image = "debian-cloud/debian-10"
        }
    }
    
    network_interface {
        subnetwork = google_compute_subnetwork.private[count.index].id
    }
}


# create a compute instance topology 1-to-1 test
resource "google_compute_instance" "test_node" {
    name         = "test-node"
    machine_type = "e2-micro"
    zone         = "asia-southeast1-a"
    tags         = ["http-server", "https-server"]
    
    boot_disk {
        initialize_params {
        image = "debian-cloud/debian-10"
        }
    }
    
    network_interface {
        subnetwork = google_compute_subnetwork.private[0].id
    }
}

# create a compute instance topology 1-to-3 Load Balancer
# resource "google_compute_instance" "lbtestnode" {
#     count        = 3
#     name         = "lbtestnode-${count.index + 1}"
#     machine_type = "e2-micro"
#     zone         = "asia-southeast1-a"
#     tags         = ["http-server", "https-server"]

#     boot_disk {
#         initialize_params {
#         image = "debian-cloud/debian-10"
#         }
#     }

#     network_interface {
#         subnetwork = google_compute_subnetwork.private[1].id
#         access_config {
#         nat_ip = google_compute_address.nat.address
#         }
#     }
# }

# create a compute instance topology 1-to-3 Load Balancer and Auto Scaling
# resource "google_compute_instance" "lbtestnode-autoscale" {
#     count        = 3
#     name         = "lbtestnode-autoscale-${count.index + 1}"
#     machine_type = "e2-micro"
#     zone         = "asia-southeast1-a"
#     tags         = ["http-server", "https-server"]

#     boot_disk {
#         initialize_params {
#         image = "debian-cloud/debian-10"
#         }
#     }

#     network_interface {
#         subnetwork = google_compute_subnetwork.private[2].id
#         access_config {
#         nat_ip = google_compute_address.nat.address
#         }
#     }
# }