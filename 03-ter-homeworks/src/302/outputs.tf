output "vm_external_ip_address-db" {
value = yandex_compute_instance.platform-db.network_interface.0.nat_ip_address
description = "vm external ip"
}

output "vm_external_ip_address-web" {
value = yandex_compute_instance.platform.network_interface.0.nat_ip_address
description = "vm external ip"
}
