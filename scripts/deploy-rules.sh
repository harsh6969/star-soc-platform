#!/bin/bash
# Deploy STAR custom rules into Wazuh manager container
# Handles the docker cp -> chown -> chmod -> restart sequence
# Avoids the silent rule-loading failure caused by wrong file ownership

set -e

RULES_FILE="$HOME/star-soc-platform/detections/wazuh/local_rules.xml"
CONTAINER="single-node-wazuh.manager-1"
CONTAINER_PATH="/var/ossec/etc/rules/local_rules.xml"

echo "[+] Copying rules into manager..."
docker cp "$RULES_FILE" "$CONTAINER:$CONTAINER_PATH"

echo "[+] Fixing ownership (wazuh:wazuh) and mode (640)..."
docker exec "$CONTAINER" chown wazuh:wazuh "$CONTAINER_PATH"
docker exec "$CONTAINER" chmod 640 "$CONTAINER_PATH"

echo "[+] Restarting Wazuh manager..."
docker exec "$CONTAINER" /var/ossec/bin/wazuh-control restart

echo "[+] Verifying rules loaded:"
docker exec "$CONTAINER" grep "rule id" "$CONTAINER_PATH"

echo "[+] Done."
