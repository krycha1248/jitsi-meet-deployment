module "vm_ovh" {
  source      = "git::https://github.com/krycha1248/terraform-modules.git//vm-ovh?ref=master"
  name        = "Jitsi"
  image_name  = "Debian 13"
  key_pair    = var.ssh_key
  flavor_name = "d2-2"
}

module "da_dns_A" {
  source = "git::https://github.com/krycha1248/terraform-modules.git//da-dns?ref=master"

  da_user      = var.da_user
  da_pass      = var.da_pass
  da_host      = var.da_host
  domain       = var.da_domain
  record_name  = "meet"
  record_type  = "A"
  record_value = module.vm_ovh.ip
}

module "da_dns_CNAME" {
  source = "git::https://github.com/krycha1248/terraform-modules.git//da-dns?ref=master"

  depends_on   = [module.da_dns_A]
  da_user      = var.da_user
  da_pass      = var.da_pass
  da_host      = var.da_host
  domain       = var.da_domain
  record_name  = "www.meet"
  record_type  = "CNAME"
  record_value = "${module.da_dns_A.record_name}.${module.da_dns_A.domain}."
}

resource "ansible_playbook" "jitsi" {
  name       = module.vm_ovh.ip
  playbook   = "${path.module}/../ansible/site.yml"
  replayable = true
  extra_vars = {
    jitsi_domain                 = module.da_dns_CNAME.record_value
    become                       = true
    ansible_user                 = "debian"
    ansible_ssh_private_key_file = var.ssh_private_key_file
    ansible_port                 = 22
  }
}

output "ansible_stdout" {
  value = ansible_playbook.jitsi.ansible_playbook_stdout
}