locals {
   name_web = "${ var.vm_name }"-"${ var.vm_web_role }"
   name_db  = "${ var.vm_name }"-"${ var.vm_db_role }"
}
