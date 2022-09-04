resource "digitalocean_droplet" "devbox" {
  image  = var.image
  name   = var.name
  region = var.region
  size   = var.size
  tags   = var.tags

  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  monitoring = true

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Ready to continue"]

    connection {
      host  = self.ipv4_address
      type  = "ssh"
      user  = "root"
      agent = "true"
    }
  }

  provisioner "local-exec" {
    working_dir = "${path.cwd}/ansible"
    command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},'  setup-devbox.yml"
  }
}

output "droplet_ip_addresses" {
  value = {
    "Your Development machine IP is:" = digitalocean_droplet.devbox.ipv4_address
  }
}