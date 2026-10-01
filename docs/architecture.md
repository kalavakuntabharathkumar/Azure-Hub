# Architecture and validation

The hub VNet hosts shared networking and a reserved `GatewaySubnet`. The spoke VNet hosts the application and data subnets. VNet peering provides private address-space connectivity; route tables make next-hop intent explicit. Two Linux VMs are attached to the application subnet and represented in a Standard Load Balancer backend pool.

## Deliberate fault-injection checklist
1. Remove the HTTP allow rule from the spoke NSG; verify the effective security rules and restore the rule.
2. Change the spoke subnet route prefix; inspect effective routes and restore the intended prefix.
3. Disable one side of VNet peering; inspect peering state on both VNets.
4. Remove forwarded-traffic permission; compare Network Watcher connectivity results.
5. Use an incorrect destination port in a connectivity test; verify the reported failure stage.
6. Associate the wrong route table with the app subnet; inspect effective routes and correct the association.

For each test, capture the source VM, destination, port, Network Watcher result, root cause, and remediation. Do not run fault injection in a production network.

## Operational checks
- `terraform fmt -recursive`
- `terraform validate`
- `terraform plan` after apply to check for drift
- `az network watcher test-connectivity` for path diagnostics
- `az network nic list-effective-nsg` and `az network nic show-effective-route-table` for VM NIC inspection
