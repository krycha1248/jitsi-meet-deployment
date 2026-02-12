terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.11"
    }
    http = {
      source = "rios0rios0/http"
    }
  }
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/"
  domain_name = "default"
}

provider "ovh" {
  endpoint = "ovh-eu"
}
