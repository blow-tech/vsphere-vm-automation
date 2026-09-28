# Preparing the Ubuntu template

Guest customization (hostname, static IP, DNS) only works if the template is prepared correctly.
These steps target Ubuntu 22.04 LTS and also apply to 24.04. Ubuntu 20.04 is past standard support; avoid it for new builds.

> Take a snapshot of the VM before you start. Converting to a template is easy to repeat, undoing a bad cleanup is not.

## 1. Install required packages

```bash
sudo apt update
sudo apt install -y open-vm-tools perl cloud-init
```

## 2. Allow VMware guest customization via cloud-init

In `/etc/cloud/cloud.cfg`, set:

```yaml
disable_vmware_customization: false
```

Also make sure cloud-init can use the OVF/VMware datasource, for example in `/etc/cloud/cloud.cfg.d/99-vmware.cfg`:

```yaml
datasource_list: [ OVF, VMware, None ]
```

Behavior varies between cloud-init versions, so verify on your build: deploy a test clone and check the logs (see Troubleshooting).

## 3. Remove per-machine identity

```bash
sudo cloud-init clean --logs
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
sudo rm -f /etc/ssh/ssh_host_*        # regenerated on first boot; see note
sudo rm -f /etc/netplan/50-cloud-init.yaml
history -c && sudo shutdown -h now
```

Note: if SSH host keys are removed, make sure something regenerates them at first boot
(`sudo dpkg-reconfigure openssh-server` via a first-boot unit, or cloud-init's `ssh` module).
Skipping this step means every clone shares the same host keys.

## 4. Convert to template

In vCenter: right-click the powered-off VM, then **Template > Convert to Template**.

## Troubleshooting

- Customization did not apply: check `/var/log/vmware-imc/toolsDeployPkg.log` and `/var/log/cloud-init.log` on the clone.
- Duplicate hostnames or DHCP leases: `machine-id` was not cleared before templating.
- Customization stuck: confirm VMware Tools is running in the template and the guest OS type in vCenter matches.
