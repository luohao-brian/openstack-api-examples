# Configure the OpenStack Provider
provider "openstack" {
  user_name   = "hwcloud5967"
  tenant_name = "cn-north-1"
  domain_name = "hwcloud5967"
  password    = ""
  auth_url    = "https://iam.cn-north-1.myhwclouds.com/v3"
  region      = "cn-north-1"
}

# Create VPC
resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "10.10.10.0/24"
  ip_version = 4
}

resource "openstack_networking_router_v2" "router_1"{
  name = "router_1"
}

resource "openstack_networking_router_interface_v2" "router_interface_1"{
  subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
  router_id = "${openstack_networking_router_v2.router_1.id}"
}

# Create security group
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "security group"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

# Create VM
resource "openstack_compute_instance_v2" "instance" {
  name = "terraform"
  image_id = "8577d625-ee57-4723-a3f2-31a2b7fc8c87"
  flavor_name = "c2.xlarge"
  key_pair = "KeyPair-terraform"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]
  availability_zone = "cn-north-1a"
  network = {
    uuid = "${openstack_networking_network_v2.network_1.id}"
  }
  depends_on = ["openstack_networking_router_interface_v2.router_interface_1"]
}

# Create Volume
resource "openstack_blockstorage_volume_v2" "myvol" {
  name = "myvol"
  size = 10
  availability_zone = "cn-north-1a"
}

resource "openstack_compute_volume_attach_v2" "attached" { 
  instance_id = "${openstack_compute_instance_v2.instance.id}"
  volume_id = "${openstack_blockstorage_volume_v2.myvol.id}"
}

# Bind Floating Ip
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "admin_external_net"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.instance.id}"
}
