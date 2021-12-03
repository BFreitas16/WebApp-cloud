# Terraform GCP
# To output variables, follow pattern:
# value = TYPE.NAME.ATTR

output "balancer" {
    value = join(" ", google_compute_instance.balancer.*.network_interface.0.access_config.0.nat_ip)
}

output "balancer_ssh" {
 value = google_compute_instance.balancer.self_link
}

# example for a set of identical instances created with "count"
output "rocketchat_IPs"  {
  value = formatlist("%s = %s", google_compute_instance.rocketchat[*].name, google_compute_instance.rocketchat[*].network_interface.0.access_config.0.nat_ip)
}

output "prometheus_IPs"  {
  value = join(" ", google_compute_instance.prometheus.*.network_interface.0.access_config.0.nat_ip)
}

output "grafana_IPs"  {
  value = join(" ", google_compute_instance.grafana.*.network_interface.0.access_config.0.nat_ip)
}
