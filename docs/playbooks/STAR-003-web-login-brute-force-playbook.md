# STAR-003 Incident Response Playbook — Banking Web Login Brute Force

**Triggered by:** Wazuh rule 100300 (custom)
**Underlying events:** Wazuh rule 100310 (STAR atomic — failed login at /rest/user/login), correlated 5x in 60s from same source IP
**Log source:** nginx access log (reverse proxy in front of banking application)
**MITRE Tactic:** TA0006 — Credential Access
**MITRE Technique:** T1110.001 — Brute Force: Password Guessing (web context)
**Severity:** Medium-High (level 10)
**Average MTTR target:** < 15 minutes

---

## 1. What just happened

A single source IP submitted five or more failed POST requests to the banking application's login endpoint (/rest/user/login), all within sixty seconds. This is the signature of a credential brute-force or credential-stuffing attack against the online banking portal — bots running automated password guessing or replaying leaked credential lists hoping any combination succeeds.

In banking this is one of the most common active attack patterns globally and a leading cause of account takeover incidents.

---

## 2. Immediate triage questions

- Is the source IP from a known internal range (load tester, monitoring tool, internal staff)? Investigate as misconfiguration first if so.
- Was any login attempt successful (200 response) from this IP after the failures?
- How many distinct email addresses were tried? (Credential stuffing typically uses many; brute force typically targets one.)
- Is the same IP firing other STAR detections (SSH brute force, recon)?

---

## 3. Investigation steps

1. Search nginx logs and Wazuh for all activity from the source IP in the last 24 hours.
2. Identify whether the attack targeted a real customer email or random/fake addresses.
3. Look up source IP in threat intelligence (AbuseIPDB, AlienVault OTX).
4. Check whether any successful login (200 to /rest/user/login) followed the failures from the same IP.
5. Pivot: search for the source IP across all monitored agents/log sources.

---

## 4. Containment

**Short-term:** Block source IP at perimeter firewall or WAF for 60 minutes (Shuffle workflow). If threat intel rates the IP as malicious, escalate to permanent block.

**Long-term:** Enable rate limiting on /rest/user/login at the reverse proxy. Add CAPTCHA after N failed attempts. Implement progressive lockout for targeted accounts. Subscribe to credential-leak monitoring services to detect when banking customer credentials appear in dumps.

---

## 5. Escalation criteria

Escalate immediately to Tier 2 / IR Lead if:
- A successful login (200) is observed from the same source IP.
- The targeted email belongs to a high-value or privileged customer account.
- The same IP is also firing STAR-001 (SSH brute force) — indicates broad attack.
- Threat intelligence rates the IP as a known credential-stuffing actor.

---

## 6. Close-out

Note in the ticket: source IP, target email(s), number of attempts, time window, whether any successful login followed, threat-intel verdict, containment actions taken, MITRE technique T1110.001 confirmed in web context.
