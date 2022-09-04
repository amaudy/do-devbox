data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "digitalocean_firewall" "devbox" {
  name = "demo-devbox-firewall"

  droplet_ids = [digitalocean_droplet.devbox.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = ["${chomp(data.http.myip.body)}/32"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}