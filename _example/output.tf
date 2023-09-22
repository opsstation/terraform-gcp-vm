output "name" {
  value = module.compute_instance.name
}

output "self_link" {
  value = module.compute_instance.self_link
}

output "id" {
  value = module.compute_instance.id
}

output "instance_id" {
  value = module.compute_instance.instance_id
}

output "metadata_fingerprint" {
  value = module.compute_instance.metadata_fingerprint
}

#output "tags_fingerprint" {
#  value = module.compute_instance.tags_fingerprint
#}

output "label_fingerprint" {
  value = module.compute_instance.label_fingerprint
}

output "cpu_platform" {
  value = module.compute_instance.cpu_platform
}