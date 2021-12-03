#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get -y upgrade

# install tools for managing ppa repositories
sudo apt-get -y install software-properties-common
sudo apt-get -y install zip unzip
sudo apt-get -y install build-essential
# 
sudo apt-get -y install libssl-dev 
sudo apt-get -y install libffi-dev 
# required for Openstack SDK
sudo apt-get -y install python3-dev 
sudo apt-get -y install python3-pip

# Add graph builder tool for Terraform
sudo apt-get -y install graphviz

# install Ansible (http://docs.ansible.com/intro_installation.html)
sudo apt-add-repository -y -u ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible

# Install Terraform
sudo apt-get update
# install GNU Privacy Guard
sudo apt-get install -y gnupg
# add HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get -y install terraform

# Install Google Cloud SDK
snap install google-cloud-sdk --classic

# Install Kubernetes Controller
sudo snap install kubectl --classic

# Clean up cached packages
sudo apt-get clean all

# Install istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.9.2 sh -
mv istio-1.9.2 tools/terraform/cluster/

# Define the right permissions for the private key
sudo chmod 600 /home/vagrant/.ssh/id_rsa
