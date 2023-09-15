output "ec2_instance_ids" {
  # Use the "module.module-name.output" syntax
  # to get the modules output variables
  value = module.ec2_instance_web[*].id

}

output "ec2_instance_ids_name" {
  # Use the "module.module-name.output" syntax
  # to get the modules output variables
  value = module.ec2_instance_app[*].id

}

output "active_directory_id" {
  # Use the "module.module-name.output" syntax
  # to get the modules output variables
  value = aws_directory_service_directory.example.id
}

output "volume_AZ" {
  value = aws_ebs_volume.volume[*].availability_zone
}

output "volume_ID" {
  value = aws_ebs_volume.volume[*].id
}