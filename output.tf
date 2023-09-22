output "id" {
  value = join("", google_compute_instance.default.*.instance_id)
}

output "name" {
  value = join("", google_compute_instance.default.*.name)
}

output "instance_id" {
  value = join("", google_compute_instance.default.*.instance_id)
}

output "metadata_fingerprint" {
  value = join("", google_compute_instance.default.*.metadata_fingerprint)
}

output "self_link" {
  value = join("", google_compute_instance.default.*.self_link)
}

output "tags_fingerprint" {
  value = join("", google_compute_instance.default.*.tags_fingerprint)
}

output "label_fingerprint" {
  value = join("", google_compute_instance.default.*.label_fingerprint)
}

output "cpu_platform" {
  value = join("", google_compute_instance.default.*.cpu_platform)
}

output "current_status" {
  value = join("", google_compute_instance.default.*.current_status)
}

