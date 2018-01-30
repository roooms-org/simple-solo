output "instance_public_dns" {
  description = "Public DNS address"
  value       = "${aws_instance.main.public_dns}"
}

output "instance_random_pet" {
  description = "Random pet name added to instance"
  value       = "${random_pet.main.id}"
}
