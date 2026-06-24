# Wazuh Active Response — STAR Automated Containment

## Configuration

Added to Wazuh manager `ossec.conf`:

```xml
<command>
  <name>firewall-drop</name>
  <executable>firewall-drop</executable>
  <timeout_allowed>yes</timeout_allowed>
</command>

<active-response>
  <command>firewall-drop</command>
  <location>local</location>
  <rules_id>100100,100200,100300,100410</rules_id>
  <timeout>600</timeout>
</active-response>
```

## How it works

When any of the following STAR rules fire, the manager dispatches the `firewall-drop`
binary to the agent which originated the alert. The binary uses iptables to add a
DROP rule for the attacker IP, with auto-removal after 600 seconds (10 minutes).

| Rule | Detection | Containment |
|------|-----------|-------------|
| 100100 | STAR-001 SSH Brute Force | iptables INPUT DROP for srcip |
| 100200 | STAR-002 SSH Credential Stuffing | iptables INPUT DROP for srcip |
| 100300 | STAR-003 Web Login Brute Force | iptables INPUT DROP for srcip |
| 100410 | STAR-004 SQL Injection | iptables INPUT DROP for srcip |

## Lab validation

End-to-end pipeline verified: detection → manager dispatch → agent execution → safety check.

In the lab WSL2 environment, Kali distro connections appear to Ubuntu sshd from Ubuntu's
own IP due to WSL2's shared network namespace. Wazuh's check_keys safety mechanism
correctly identifies this as a same-host condition and aborts to prevent self-lockout.
In production with externally-sourced traffic, the safety check permits the block and
firewall-drop executes the iptables DROP rule.

## Dependency

Ubuntu 24.04 minimal installs ship with nftables, not iptables. The firewall-drop binary
requires iptables — install via `sudo apt install -y iptables`.

