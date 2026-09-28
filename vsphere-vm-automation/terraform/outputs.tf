output "vm_ips" {
  description = "Map of VM name to configured IP"
  value       = { for name, vm in vsphere_virtual_machine.vm : name => vm.default_ip_address }
}
