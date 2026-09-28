terraform {
  required_version = ">= 1.6"
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.8"
    }
  }
}

provider "vsphere" {
  vsphere_server       = var.vcenter_server
  user                 = var.vcenter_user
  password             = var.vcenter_pass
  allow_unverified_ssl = var.allow_unverified_ssl
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cl" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "net" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "tpl" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  for_each = var.vms

  name             = each.key
  resource_pool_id = data.vsphere_compute_cluster.cl.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  folder           = var.vm_folder
  num_cpus         = each.value.cpus
  memory           = each.value.memory
  guest_id         = data.vsphere_virtual_machine.tpl.guest_id
  scsi_type        = data.vsphere_virtual_machine.tpl.scsi_type

  network_interface {
    network_id = data.vsphere_network.net.id
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.tpl.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.tpl.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.tpl.id

    customize {
      linux_options {
        host_name = each.key
        domain    = var.domain
      }
      network_interface {
        ipv4_address = each.value.ip
        ipv4_netmask = var.netmask_bits
      }
      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
    }
  }
}
