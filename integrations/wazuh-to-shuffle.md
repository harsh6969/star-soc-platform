# Wazuh → Shuffle Integration

## Configuration

Added to Wazuh manager `ossec.conf` (inside `<ossec_config>` block):

```xml
<integration>
  <name>shuffle</name>
  <hook_url>http://host.docker.internal:3001/api/v1/hooks/webhook_<UUID></hook_url>
  <level>8</level>
  <alert_format>json</alert_format>
</integration>
```

## Critical notes

- `host.docker.internal` resolves from inside Wazuh manager container to the host
  where Shuffle's port 3001 is exposed. Necessary because `localhost` from inside
  the container refers to the container itself.
- The `<name>shuffle</name>` value invokes Wazuh's built-in integration script at
  `/var/ossec/integrations/shuffle`, which POSTs alerts as JSON.
- Level threshold of 8 filters out info/low-severity noise; all STAR custom rules
  (level 10+) qualify automatically.
- After editing ossec.conf inside the container, `chown root:wazuh` and `chmod 660`
  must be applied or Wazuh silently fails to load the file (same gotcha as
  `local_rules.xml`).

## Validation

The first webhook-triggered run in Shuffle showed the STAR-001 alert payload:
"$exec": {

"rule_id": "100100",

"title": "STAR: Banking SSH brute force — 5+ failed SSH logins from <IP> in 60s",

"severity": 3,

"pretext": "WAZUH Alert",

...

}
Status: integration validated end-to-end on 2026-06-24.
