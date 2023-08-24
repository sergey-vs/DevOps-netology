locals {
   name_web = "${ var.vm_web_name }"
   name_db = "${ var.vm_db_name }"
}

locals {
  metadata = {serial-port-enable = "1", ssh-keys = "ubuntu:${var.vms_ssh_root_key}"}
}
