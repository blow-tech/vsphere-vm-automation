# Script remediation — 8 November 2026

Ansible VM deployment now requires ipam_reservation_confirmed and ipam_reserved_ip exactly matching vm_ip. Silent ping cannot establish address availability; the ping probe was removed. Trusted vCenter certificate validation is required and module output containing inventory/credentials is suppressed. Baseline apt upgrades now require approved_patch_window; package/service installation remains an explicit deployment change.

No infrastructure executed. IPAM reservation, template suitability, duplicate-VM handling, Terraform lifecycle/state/backup, network customization and rollback remain lab/change-plan prerequisites. Local YAML parsing/CI syntax are not a deployment certification. No performance benchmarks.

Local validation: YAML parsing; VMware PowerCLI connection-scope/failure/WWPN/JSON fixtures passed in PowerShell 7.4.13 for the migration repository. Windows versions and Ansible contracts are checked by the PR CI; infrastructure integration remains unverified.
