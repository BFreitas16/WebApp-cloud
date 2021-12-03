# Terraform google cloud multi tier Kubernetes deployment
# AGISIT Cloud-Native Application in a Kubernetes Cluster

#################################################################
# Definition of the Pods
#################################################################
# Defines 1 rocketchat-mongo  (not replicated)
resource "kubernetes_stateful_set" "rocketchat-mongo" {
  metadata {
    name = "rocketchat-mongo"

    labels = {
      app  = "rocketchat-mongo"
      tier = "backend"
    }
    namespace = kubernetes_namespace.application.id
  }

  spec {
    service_name = "rocketchat-mongo"
    replicas = 2

    selector {
      match_labels = {
        app  = "rocketchat-mongo"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "rocketchat-mongo"
          tier = "backend"
        }
      }

      spec {        
        termination_grace_period_seconds = 10
        
        container {
          name              = "rocketchat-mongo"
          image             = "mongo:4.0"
          image_pull_policy = "IfNotPresent"

          command = ["mongod"]
          args = [ "--smallfiles", "--replSet", "rs0", "--bind_ip_all", "--noprealloc" ]

          port {
            container_port = 27017
          }

          volume_mount {
            name       = "mongo-db"
            mount_path = "/data/db"
          }
        }

        # 2nd container is the sidecar container that will automatically configure the new MongoDB nodes to join the replica set.
        container {
          name              = "rocketchat-mongo-sidecar"
          image             = "cvallance/mongo-k8s-sidecar"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "MONGO_SIDECAR_POD_LABELS"
            value = "app=rocketchat-mongo,tier=backend"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "mongo-db"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "5Gi"
          }
        }        
      }
    }
  }

  depends_on = [
    helm_release.istiod,
    kubernetes_namespace.application
  ]
}

# Defines 2 rocketchat fronted
resource "kubernetes_deployment" "rocketchat-server" {
  metadata {
    name = "rocketchat-server"

    labels = {
      app  = "rocketchat-server"
      tier = "frontend"
    }
    namespace = kubernetes_namespace.application.id
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app  = "rocketchat-server"
        tier = "frontend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "rocketchat-server"
          tier = "frontend"
        }
      }

      spec {
        container {
          image = "rocketchat/rocket.chat:latest"
          name  = "rocketchat-server"

          port {
            container_port = 3000
          }
          env {
            name  = "Site_Url"
            value = "http://localhost"
          }
          env {
            name  = "PORT"
            value = "3000"
          }
          env {
            name  = "ROOT_URL"
            value = "http://localhost:3000"
          }
          env {
            name  = "MONGO_URL"
            value = "mongodb://rocketchat-mongo-0.rocketchat-mongo.application,rocketchat-mongo-1.rocketchat-mongo.application:27017/rocketchat" 
          }

          env {
            name  = "MONGO_OPLOG_URL"
            value = "mongodb://rocketchat-mongo-0.rocketchat-mongo.application,rocketchat-mongo-1.rocketchat-mongo.application:27017/local?replSet=rs0"
          }

        }
      }
    }
  }

  depends_on = [
    helm_release.istiod,
    kubernetes_namespace.application,
    kubernetes_stateful_set.rocketchat-mongo
#    kubernetes_service.rocketchat-mongo
  ]
}

#################################################################
# Definition of Role Binding for MongoDB - ERROR 'pods is forbidden: User "system:serviceaccount:application:default" cannot list resource'
#################################################################
resource "kubernetes_cluster_role_binding" "default-view" {
  metadata {
    name = "default-view"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "application"
  }
}
