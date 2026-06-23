# STAR-002 Incident Response Playbook — Banking SSH Credential Stuffing

**Triggered by:** Wazuh rule 100200 (custom)
**Underlying events:** Wazuh rule 5710 (sshd: invalid user), correlated 3x in 60s from same source IP
**MITRE Tactic:** TA0006 — Credential Access
**MITRE Technique:** T1110.004 — Brute Force: Credential Stuffing
**Severity:** Medium-High (level 10)
**Average MTTR target:** < 15 minutes

---

## 1. What just happened

A single source IP attempted to log in over SSH using three or more different usernames that do not exist on the target host, all within sixty seconds. This is the signature of either user enumeration (probing to learn which accounts exist) or credential stuffing (replaying leaked username/password pairs). In a banking environment, credential stuffing is the leading attack vector against customer-facing services and admin portals globally.

---

## 2. Immediate triage questions

- Is the source IP from a known internal range (developer host, scanner, monitoring tool)? Investigate as misconfiguration first if so.
- What usernames were attempted? Are any sensitive (root, admin, service accounts, real employee names)?
- Has any login succeeded from this IP in the last 24 hours (rule 5715)?
- Is the same IP also firing STAR-001 (password brute force)?

---

## 3. Investigation steps

1. Pull all auth events from the source IP for the last 24 hours.
2. Extract the list of usernames attempted — useful tooling indicator.
3. Look up source IP in threat intelligence (AbuseIPDB, AlienVault OTX).
4. Check whether any real account was attempted (rule 5760 from same IP).
5. Search for the same IP across all monitored agents.

---

## 4. Containment

**Short-term:** Block source IP at perimeter firewall for 60 minutes. If threat intel rates the IP malicious, escalate to permanent block.

**Long-term:** Review which accounts were probed; notify users if real names appear and force credential reset. Audit external SSH exposure (consider VPN-only access). Enforce key-based SSH authentication.

---

## 5. Escalation criteria

Escalate immediately if:
- A successful login (rule 5715) is observed from the same source IP.
- Real internal usernames appear in the attempt list.
- The same IP is attacking multiple hosts.
- Threat intel rates the IP as a known credential-stuffing actor.

---

## 6. Close-out

In the ticket, note: source IP, list of usernames attempted, timing window, whether any real account name was hit, threat-intel verdict, containment actions taken, and confirm MITRE technique T1110.004 — Credential Stuffing.
