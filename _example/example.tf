provider "google" {
  project = "opsstation-474608"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}
#------------------------------------------(vpc)--------------------------------------------------------------
module "vpc" {
  source                                    = "opsstation/vpc/gcp"
  version                                   = "1.0.1"
  name                                      = "vpc"
  environment                               = "OpsStation"
  label_order                               = ["name", "environment"]
  mtu                                       = 1460
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  network_enabled                           = true
  delete_default_routes_on_create           = false
}


#------------------------------------------(subnet)------------------------------------------------------------
module "subnet" {
  #  source        = "opsstation/subnet/gcp"
  #  version       = "1.0.1"
  source        = "git::git@github.com:opsstation/terraform-gcp-subnet.git?ref=update/module"
  name          = ["dev"]
  environment   = "test"
  region        = "asia-northeast1"
  network       = module.vpc.vpc_id
  ip_cidr_range = ["10.10.1.0/24"]
  log_config = {
    enable               = true
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    metadata_fields      = []
    filter_expr          = null
  }
}

#------------------------------------------(firewall)--------------------------------------------------------------
module "firewall" {
  #  source      = "opsstation/firewall/gcp"
  #  version     = "1.0.1"
  source      = "git::git@github.com:opsstation/terraform-gcp-firewall.git?ref=feat/release-1"
  name        = "firewall"
  environment = "OpsStation"
  network     = module.vpc.vpc_id
  ingress_rules = [
    {
      name          = "allow-tcp-http-ingress"
      description   = "Allow TCP, HTTP ingress traffic"
      disabled      = false
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22", "80"]
        }
      ]
    }
  ]
}


#------------------------------------------(compute_instance)--------------------------------------------------------------
module "compute_instance" {
  source                 = "./../"
  name                   = "dev"
  environment            = "test"
  instance_count         = 1
  zone                   = "asia-northeast1-a"
  instance_tags          = ["foo", "bar"]
  machine_type           = "e2-small"
  image                  = "ubuntu-2204-jammy-v20230908"
  service_account_scopes = ["cloud-platform"]
  subnetwork             = module.subnet.subnet_id
  network                = module.vpc.vpc_id

  enable_public_ip = true # Enable public IP only if enable_public_ip is true
  metadata = {
    ssh-keys = <<EOF
      ubuntu:ssh-rsa AAAAB3NzaCph/FXUAHBaekf+hzL58= suresh@suresh
    EOF
  }
}