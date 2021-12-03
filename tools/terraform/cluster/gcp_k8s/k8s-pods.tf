# Terraform google cloud multi tier Kubernetes deployment
# AGISIT Cloud-Native Application in a Kubernetes Cluster

#################################################################
# Definition of the Pods
#################################################################
# Defines 1 rocketchat-mongo  (not replicated)
resource "kubernetes_stateful_set" "rocketchat-mongo" {
  metadata {
    name = "rocketchat-mongo"
  }

  spec {
    service_name = "rocketchat-mongo"
    replicas = 1

    selector {
      match_labels = {
        app  = "rocketchat-mongo"
      }
    }

    template {
      metadata {
        labels = {
          app  = "rocketchat-mongo"
        }
      }

      spec {        
        termination_grace_period_seconds = 10
        
        container {
          name              = "rocketchat-mongo"
          image             = "mongo:4.0"
          image_pull_policy = "IfNotPresent"

          command = ["mongod"]
          args = [ "--replSet","rs0","--smallfiles","--oplogSize","128","--storageEngine=mmapv1" ]

          port {
            container_port = 27017
          }

          volume_mount {
            name       = "mongo-db"
            mount_path = "/data/db"
          }
        }

        # container to initialize the replica set
        #container {
        #  name              = "init-replica-set"
        #  image             = "mongo:4.0"
        #  image_pull_policy = "IfNotPresent"
        #
        #  command = ["/bin/sh", "-c", "for i in `seq 1 30`; do mongo mongo/rocketchat --eval \"rs.initiate({_id: 'rs0',members: [ { _id: 0, host: 'rocketchat-mongo-0.rocketchat-mongo:27017' } ]})\" &&s=$$? && break || s=$$?; echo \"Tried $$i times. Waiting 5 secs...\"; sleep 5; done; (exit $$s)"]
        #}
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
}

# Defines 2 rocketchat fronted
resource "kubernetes_deployment" "rocketchat-server" {
  metadata {
    name = "rocketchat-server"

    labels = {
      app  = "rocketchat-server"
      tier = "frontend"
    }
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
            name  = "PORT"
            value = "3000"
          }
          env {
            name  = "MONGO_URL"
            value = "mongodb://rocketchat-mongo-0.rocketchat-mongo:27017/rocketchat" 
          }

          env {
            name  = "MONGO_OPLOG_URL"
            value = "mongodb://rocketchat-mongo-0.rocketchat-mongo:27017/local?replSet=rs0"
          }

        }
      }
    }
  }
}


