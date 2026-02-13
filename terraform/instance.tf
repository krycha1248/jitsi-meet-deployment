module "vm_ovh" {
  source      = "git::https://github.com/krycha1248/terraform-modules.git//vm-ovh?ref=master"
  name        = "Jitsi"
  image_name  = "Debian 12"
  key_pair    = var.ssh_key
  flavor_name = "d2-2"
}

module "da_dns_A" {
  source = "git::https://github.com/krycha1248/terraform-modules.git//da-dns?ref=master"

  da_user      = var.da_user
  da_pass      = var.da_pass
  da_host      = var.da_host
  domain       = var.da_domain
  record_name  = var.subdomain
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
  record_name  = "www.${var.subdomain}"
  record_type  = "CNAME"
  record_value = "${module.da_dns_A.record_name}.${module.da_dns_A.domain}."
}

resource "ansible_playbook" "jitsi" {
  name       = module.vm_ovh.ip
  playbook   = "${path.module}/../ansible/deploy.yml"
  replayable = true
  extra_vars = {
    domain_name                  = "${module.da_dns_A.record_name}.${var.da_domain}"
    become                       = true
    ansible_user                 = "debian"
    ansible_ssh_private_key_file = var.ssh_private_key_file
    ansible_port                 = 22
    username                     = var.da_user
    password                     = var.da_pass
    meet_cert_mail               = var.mail
    meet_admin_pass              = var.admin_pass
  }
}

output "ansible_stdout" {
  value = ansible_playbook.jitsi.ansible_playbook_stdout
}
