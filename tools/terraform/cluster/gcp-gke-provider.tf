# Terraform google cloud multi tier Kubernetes deployment
# AGISIT Cloud-Native Application in a Kubernetes Cluster
# Check how configure the provider here:
# https://www.terraform.io/docs/providers/google/index.html

provider "google" {
    # Create/Download your credentials from:
    # Google Console -> "APIs & services -> Credentials"
    credentials = file("../agisit-2021-rocketchat-06.json")
}
