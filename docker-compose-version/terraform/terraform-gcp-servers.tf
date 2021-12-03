# Terraform GCP multi tier deployment

# Elements of the cloud such as virtual servers,
# networks, firewall rules are created as resources
# syntax is: resource RESOURCE_TYPE RESOURCE_NAME
# https://www.terraform.io/docs/configuration/resources.html

###########  Load Balancer   #############
resource "google_compute_instance" "balancer" {
    name = "balancer"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_REGION

    boot_disk {
        initialize_params {
        # image list can be found at:
        # https://cloud.google.com/compute/docs/images
        image = "ubuntu-2004-lts"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }

  tags = ["balancer"]
}

###########  Web Servers   #############
# This method creates as many identical instances as the "count" index value
resource "google_compute_instance" "rocketchat" {
    count = 1
    name = "rocketchat${count.index+1}"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_REGION

    boot_disk {
        initialize_params {
        # image list can be found at:
        # https://cloud.google.com/compute/docs/images
        image = "ubuntu-2004-lts"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }
  tags = ["rocketchat"]
}

###########  Grafana Server   #############
resource "google_compute_instance" "grafana" {
    name = "grafana"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_REGION

    boot_disk {
        initialize_params {
        # image list can be found at:
        # https://cloud.google.com/compute/docs/images
        image = "ubuntu-2004-lts"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }

  tags = ["grafana"]
}

###########  Prometheus Server   #############
resource "google_compute_instance" "prometheus" {
    name = "prometheus"
    machine_type = var.GCP_MACHINE_TYPE
    zone = var.GCP_REGION

    boot_disk {
        initialize_params {
        # image list can be found at:
        # https://cloud.google.com/compute/docs/images
        image = "ubuntu-2004-lts"
        }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata = {
      ssh-keys = "ubuntu:${file("/home/vagrant/.ssh/id_rsa.pub")}"
    }

  tags = ["prometheus"]
}