#!/usr/bin/env bash
set -euo pipefail
: "${RESOURCE_GROUP:?Set RESOURCE_GROUP}"
: "${VM_NAME:?Set VM_NAME}"
az network watcher test-connectivity \
  --resource-group "$RESOURCE_GROUP" \
  --source-resource "$VM_NAME" \
  --dest-address 10.10.1.4 \
  --dest-port 443
