# STAR-001 Incident Response Playbook — Banking SSH Brute Force

**Triggered by:** Wazuh rule 100100 (custom)
**Underlying events:** Wazuh rule 5760 (sshd authentication failed), correlated 5x in 60s from same source IP
**MITRE Tactic:** TA0006 — Credential Access
**MITRE Technique:** T1110.001 — Brute Force: Password Guessing
**Severity:** Medium-High (level 10)
**Average MTTR target:** < 15 minutes

---

## 1. What just happened

A single source IP attempted to log into SSH as the same user account five or more
times within sixty seconds and failed every time. This pattern is characteristic of
brute-force credential guessing — an attacker trying a wordlist of common or leaked
passwords against a known username.

In a banking environment this matters because successful credential compromise can
lead to access to administrative interfaces, customer data systems, or payment
infrastructure.

---

## 2. Immediate triage questions

- Is the source IP from a known internal range (jump host, backup server, monitoring
  tool)? If yes, investigate as misconfiguration before treating as attack.
- Is the targeted user a privileged account (root, admin, service accounts)?
- Has any successful login followed the failures from the same source IP?
  Check Wazuh rule 5715 (Successful sudo to ROOT) or 5501 (Login session opened)
  in the same window.
- Is the same source IP attempting brute force against multiple servers? Pivot the
  search to all agents.

---

## 3. Investigation steps

1. Pull all auth events from the source IP for the last 24 hours:
   `agent.name:wazuh-manager-host AND data.srcip:"<IP>"`
2. Check whether the source IP has fired any other STAR detections in the last 7 days.
3. Look up the source IP in threat intelligence:
   - AbuseIPDB reputation
   - AlienVault OTX pulses
   - Any internal blocklist
4. Identify the targeted username — is it a real account on this host? If not, the
   attacker is enumerating; if yes, it's a targeted attempt.
5. Check for any successful logins from this IP elsewhere in the environment in the
   last 24 hours.

---

## 4. Containment

**Short-term (immediate, automated where possible):**
- Block the source IP at the perimeter firewall for 30 minutes (Shuffle workflow).
- If threat intelligence confirms the IP is malicious, escalate to permanent block.

**Long-term:**
- If the targeted user account is real, force a password reset and rotate any associated API keys or tokens.
- Review whether SSH on this host should be exposed publicly at all.
- Consider enforcing key-based authentication only (disable password auth).

---

## 5. Escalation criteria

Escalate to Tier 2 / Incident Response Lead immediately if:
- A successful login is observed from the same source IP after the brute-force attempts.
- The targeted account is a privileged or service account.
- The same source IP is attacking multiple hosts simultaneously.
- Threat intelligence rates the source IP as a known bad actor.

---

## 6. Close-out

Note in the ticket:
- Source IP, targeted username, number of attempts, duration.
- Whether any successful login followed.
- Threat-intel verdict.
- Containment actions taken.
- Confirmed MITRE technique: T1110.001.

Suggest detection improvements if observed:
- If the attacker spread attempts over longer than 60s to evade detection,
  consider adjusting timeframe.
- If the attempts used multiple usernames (not the same one), STAR-002 (credential
  stuffing detection) is the relevant pattern instead.
