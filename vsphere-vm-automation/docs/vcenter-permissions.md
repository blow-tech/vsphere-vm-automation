# vCenter service account permissions

Do not give the automation account Administrator. Create a custom role and assign it on the
target folder, cluster/resource pool, datastore, network and the template.

Typical privileges needed for clone-and-customize (verify in your vCenter version):

| Object | Privilege |
|---|---|
| Virtual machine > Provisioning | Clone template, Deploy template, Customize guest, Read customization specifications |
| Virtual machine > Inventory | Create from existing |
| Virtual machine > Change Configuration | Add new disk, Change CPU count, Change Memory, Modify device settings |
| Virtual machine > Interaction | Power on, Power off |
| Resource | Assign virtual machine to resource pool |
| Datastore | Allocate space |
| Network | Assign network |
| Folder | Create folder (only if the playbook creates folders) |

Assign the role with **propagate to children** on the destination folder, resource pool, datastore and network.
The template itself needs at least read plus clone/deploy rights.

If a task fails with `NoPermission`, the vCenter *Recent Tasks / Events* entry names the missing privilege.
Add it to the role instead of widening the account.
