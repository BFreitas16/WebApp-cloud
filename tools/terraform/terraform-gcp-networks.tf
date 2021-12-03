# Terraform GCP multi tier deployment
# creating security group to allow access to ..

resource "google_compute_firewall" "frontend_balancer_rules" {
  name    = "frontendbalancer"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["balancer"]
}

resource "google_compute_firewall" "frontend_grafana_rules" {
  name    = "frontendgrafana"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["9000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["grafana"]
}
