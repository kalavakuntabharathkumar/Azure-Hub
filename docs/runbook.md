# Network troubleshooting runbook

1. Confirm VM power state and NIC attachment.
2. Check NSG rules at both subnet and NIC scope; remember the lowest numeric priority wins.
3. Inspect effective routes for the source NIC and confirm the destination prefix matches the intended next hop.
4. Check both directions of VNet peering and forwarded-traffic/gateway-transit settings.
5. Run Network Watcher connection troubleshoot and save the JSON output with a timestamp.
6. Apply the smallest corrective change, rerun the test, then run `terraform plan` to ensure configuration and state agree.

Never solve a connectivity issue by opening all ports to the Internet. Prefer narrow source ranges and required destination ports.
