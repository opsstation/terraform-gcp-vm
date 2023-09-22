variable "name" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = ""
}

variable "label_order" {
  type    = list(any)
  default = ["name", "environment"]
}

variable "enabled" {
  type    = bool
  default = true
}

variable "machine_type" {
  type    = string
  default = ""
}

variable "zone" {
  type    = string
  default = ""
}

variable "instance_tags" {
  type    = list(string)
  default = []
}

variable "project_id" {
  type    = string
  default = ""
}

variable "image" {
  type    = string
  default = "debian-cloud/debian-11"
}

variable "subnetwork" {
  type    = string
  default = ""
}

variable "nat_ip" {
  type    = string
  default = ""
}

variable "metadata" {
  type    = map(string)
  default = {}
}

variable "metadata_startup_script" {
  type    = string
  default = ""
}

variable "service_account_email" {
  type    = string
  default = ""
}

variable "service_account_scopes" {
  type    = list(string)
  default = []
}

variable "allow_stopping_for_update" {
  type    = bool
  default = true
}

variable "gcp_zone" {
  type    = string
  default = ""
}

variable "google_compute_instance_enabled" {
  type = bool
  default = true
}

variable "source_subnetwork_ip_ranges_to_nat" {
  type = string
  default = ""
}