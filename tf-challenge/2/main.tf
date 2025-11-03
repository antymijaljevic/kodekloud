# https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image
resource "docker_image" "php-httpd-image" {
  name = "php-httpd:challenge"

  build {
    path = "lamp_stack/php_httpd"
    tag  = ["php-httpd:challenge"]
    label = {
      challenge : "second"
    }
  }
}

resource "docker_image" "mariadb-image" {
  name = "mariadb:challenge"

  build {
    path = "lamp_stack/custom_db"
    tag  = ["mariadb:challenge"]
    label = {
      challenge : "second"
    }
  }
}

# https://registry.terraform.io/providers/kreuzwerker/docker/2.16.0/docs/resources/network
resource "docker_network" "private_network" {
  name       = "my_network"
  attachable = true # Enable manual container attachment to the network.

  labels {
    label = "challenge"
    value = "second"
  }
}

# https://registry.terraform.io/providers/kreuzwerker/docker/2.16.0/docs/resources/volume
resource "docker_volume" "mariadb_volume" {
  name = "mariadb-volume"
}

# https://registry.terraform.io/providers/kreuzwerker/docker/2.16.0/docs/resources/container#nestedblock--volumes
resource "docker_container" "php-httpd" {
  name     = "webserver"
  image    = docker_image.php-httpd-image.name
  hostname = "php-httpd"

  networks_advanced {
    name = docker_network.private_network.id
  }

  ports {
    internal = 80
    external = 80
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  labels {
    label = "challenge"
    value = "second"
  }

  volumes {
    host_path      = "/root/code/terraform-challenges/challenge2/lamp_stack/website_content/"
    container_path = "/var/www/html"
  }
}

resource "docker_container" "phpmyadmin" {
  name     = "db_dashboard"
  image    = "phpmyadmin/phpmyadmin"
  hostname = "phpmyadmin"

  networks_advanced {
    name = docker_network.private_network.id
  }

  ports {
    internal = 80   # containerPort
    external = 8081 # Hostport
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  labels {
    label = "challenge"
    value = "second"
  }

  links = [docker_container.mariadb.name] # [legacy] Set of links for link based connectivity between containers that are running on the same host.

  volumes {
    volume_name    = docker_volume.mariadb_volume.name
    container_path = "/var/lib/mysql"
  }

  # https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on
  depends_on = [docker_container.mariadb]
}

resource "docker_container" "mariadb" {
  name     = "db"
  image    = docker_image.mariadb-image.name
  hostname = "db"
  env      = ["MYSQL_ROOT_PASSWORD=1234", "MYSQL_DATABASE=simple-website"]

  networks_advanced {
    name = docker_network.private_network.id
  }

  ports {
    internal = 3306
    external = 3306
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  labels {
    label = "challenge"
    value = "second"
  }

  volumes {
    volume_name    = docker_volume.mariadb_volume.name
    container_path = "/var/lib/mysql"
  }
}