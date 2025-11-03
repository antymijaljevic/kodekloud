output "maria_image" {
  value = docker_image.mariadb-image
}

output "network" {
  value = docker_network.private_network
}