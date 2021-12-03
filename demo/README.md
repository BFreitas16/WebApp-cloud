# AGI

# Demo video
[AGI-Project-team06A-21/22](https://www.youtube.com/watch?v=e5jRSE9jek8)
### Prerequisites

To run this application is required to install the following software: 

- Vagrant (latest)

- Virtualbox (latest)

To confirm that you have them installed, open a terminal and type:

```
vagrant --version

vboxmanage --version
```

<b>Vagrant</b> is necessary to create the `management machine`. This is done with a Vagrantfile that uses <b>Virtualbox</b> provider (this Vagrant file is not prepared to run on systems with architecture ARM aarch64, namely Apple Silicon M1 computers - to run this on a machine with these characteristics, another provider such as <b>Docker</b> must be used).

It is also a requirement to have a **GPC account**. With this it is possible to create a project, enable the API (see the bullet point below to further information) and then we need to download the credentials.json to the terraform folder (to authenticate the project).

* It is needed to ENABLE APIs AND SERVICES for the Project, by choosing in the Google Cloud Console API & services and next selecting the Dashboard, where it is possible to see a button on the top menu for enabling those services. Then enable `Kubernetes Engine API`.


### Deployment

This project was design to have a easy deployment. So,This project was design to have a easy deployment. So, So, the first thing to do is to go to the project directory and run the following commands to put up and connect to the `mgmt` - Management VM (bastion):
```
$ vagrant up
$ vagrant ssh mgmt
```

After this, inside the `mgmt`, run the following command to authenticate in the GCP (it will give a link, open it on a browser, login in with an IST account, copy the response code and past the verification code in the command line):
```
vagrant@mgmt:~$ gcloud auth login
```

Then, inside the `mgmt`, let's create the infrastructure by running the commands (first will initialize Terraform, in order to satisfy some plugion requiremnts; then it will create a plan and create the infratructure by running apply):
```
vagrant@mgmt:~/tools/terraform/cluster$ terraform init
vagrant@mgmt:~/tools/terraform/cluster$ terraform plan
vagrant@mgmt:~/tools/terraform/cluster$ terraform apply
```

After this, all the resources will be created. It is possible to see all the resources created running the command:

``kubectl get all -all-namespaces``

This command will get all information about all namespaces available.
In a briefly way, it is possible to see that what was deployed was:


- **RocketChat Pods** to handle the requests from the client (RocketChat servers).

- **RocketChat Service** to load-balance the client requests for the **RocketChat Pods**.

- **MongoDB Pods** to handle the requests from RocketChat servers (are the podscalled RocketChat-Mongo).

- **MongoDB Service** to be forward the traffic to **MongoDB Pods**.

- **Grafana Pods** to handle the requests for monitoring purposes.

- **Grafana Service** to load-balance the client requests for **Grafana Pods**.

- **Prometheus Pods** that collect metrics about the cluster and its resources.

- **Prometheus Service** to load-balance the client requests for the Prometheus Pods

After the deployment, if it is needed to use the tool `kubectl` for any purpose, first it is needed to run the following command, changing the parameters with anchors \<parameter> with the respective project data:

``
vagrant@mgmt:∼/tools/terrafo rm/cluster$gcloud  container  clustersget -credentials  <project_id > --zone <project_zone >
``

NOTES: 
* If we need more worker nodes we can change the `workers_count` variable in the file `terraform.tfvars`.
* If we need to change the region we can change it in the `region` variable in the file `terraform.tfvars`.
* If we need more replicas of the rocketchat-server or rocketchat-mongo we only need to change the `replicas` varibale in the file `k8s-pods.tf`. For grafana and prometheus the same variable should be change in their `respective.yml` file inside the monitoring folder.  If the cluster is already running it can also be added replicas using the kubernetes command line tool.


