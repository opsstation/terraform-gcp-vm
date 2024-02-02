provider "google" {
  project = "local-concord-408802"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}
############################################(vpc)###########################################################
module "vpc" {
  source                                    = "git::git@github.com:opsstation/terraform-gcp-vpc.git?ref=v1.0.0"
  name                                      = "dev"
  environment                               = "test"
  label_order                               = ["name", "environment"]
  mtu                                       = 1460
  routing_mode                              = "REGIONAL"
  google_compute_network_enabled            = true
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  delete_default_routes_on_create           = false
}

###########################################(subnet)###########################################################
module "subnet" {
  source        = "git::git@github.com:opsstation/terraform-gcp-subnet.git?ref=v1.0.0"
  subnet_names  = ["dev-subnet1"]
  name          = "dev"
  environment   = "test"
  label_order   = ["name", "environment"]
  gcp_region    = "asia-northeast1"
  network       = module.vpc.vpc_id
  ip_cidr_range = ["10.10.0.0/16"]
}

###########################################(firewall)###############################################################
module "firewall" {
  source        = "git::git@github.com:opsstation/terraform-gcp-firewall.git?ref=v1.0.0"
  name          = "firewall"
  environment   = "test"
  label_order   = ["name", "environment"]
  network       = module.vpc.vpc_id
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}

############################################(compute_instance)########################################################
module "compute_instance" {
  source                 = "../"
  name                   = "dev"
  environment            = "test"
  instance_count         = 2
  instance_tags          = ["foo", "bar"]
  machine_type           = "e2-small"
  image                  = "ubuntu-2204-jammy-v20230908"
  gcp_zone               = "asia-northeast1-a"
  service_account_scopes = ["cloud-platform"]
  subnetwork             = module.subnet.subnet_id

  # Enable public IP only if enable_public_ip is true
  enable_public_ip = true
  metadata = {
    ssh-keys = <<EOF
      test:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx9HrdPJD7zv9SJlAKlssHr2CUSvifRBy+bRp2jRvP851p8RiMshlbrkaRAJV7gh0AFAxL6S7znWzGwFQZFv/XP9fEqD8B7XEOtVIZK+99AYRZfkO62WG5BR6vmN1u3ei2zHSY2IuCmita27BOaimfUCXFdPMUMXwKoTMvThK6UVKaoa+IWR7qkG0b7ByLKZBTsCgBlXH4xLkZsFdCsEDWog4ZJcY5F2tPwZkHoqI0g45CcJMlsfC1KMOkN0MLPAR/iR/wfsQ9Zp0GGFwAn3uJXrcAjUGv1/+giw7RYEnmR3PA5CpzuTNJrnNI2KoFUmh7HSRt5atNg0AEj+043I7B23/yKNBaiqqaNSiv5/qO29n1eSkDhQ7l2sLxAcMS3PkTMKcsf89KkqHDt8AEBWUuCPwVTrsSwAF1Fcfj4Fe4LQUYogM5d+Y3u95LdaaCizM8i/RJ0R6aR//OLtvlHeGJFVjSPiazVJea8ZvR+4nO4b67ic6YZvwfVCEUw+ttbb0= kamal@kamal
    EOF
  }
}