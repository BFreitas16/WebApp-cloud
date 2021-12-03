# Terraform google cloud multi tier Kubernetes deployment
# AGISIT Cloud-Native Application in a Kubernetes Cluster

#################################################################
# Definition of the Services
#################################################################
# The Service for the rocketmongo Pods
resource "kubernetes_service" "rocketchat-mongo" {
  metadata {
    name = "rocketchat-mongo"

    labels = {
      app  = "rocketchat-mongo"
      tier = "backend"
    }
    namespace = kubernetes_namespace.application.id
  }

  spec {
    selector = {
      app  = "rocketchat-mongo"
      tier = "backend"
    }

    port {
      port        = 27017
      target_port = 27017
    }

    cluster_ip = "None"
  }
}

# The Service for the rocketchat-server Pods
resource "kubernetes_service" "rocketchat-server" {
  metadata {
    name = "rocketchat-server"

    labels = {
      app  = "rocketchat-server"
      tier = "frontend"
    }
    namespace = kubernetes_namespace.application.id
  }

  spec {
    selector = {
      app  = "rocketchat-server"
      tier = "frontend"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}


