# STAR-004 Incident Response Playbook — Banking Web SQL Injection

**Triggered by:** Wazuh rule 100410 (custom)
**Underlying events:** Wazuh rule 31100 (web access log) + custom SQLi pattern match
**Log source:** nginx access log (reverse proxy in front of banking application)
**MITRE Tactic:** TA0001 — Initial Access
**MITRE Technique:** T1190 — Exploit Public-Facing Application
**Severity:** High (level 10)
**Average MTTR target:** < 10 minutes (high-priority, single-event detection)

---

## 1. What just happened

A request was observed against the banking web application containing SQL injection signatures in the URL — patterns such as UNION SELECT, OR 1=1, time-based blind probes (SLEEP, WAITFOR DELAY), or boolean-based blind injection. These patterns have no legitimate business use case in normal banking traffic and indicate an active attempt to exploit a SQL injection vulnerability in the application.

In banking this is a critical signal because successful SQL injection can lead to direct database access — customer records, account balances, transaction history, even password hashes — and is one of the top vectors for major bank data breaches.

---

## 2. Immediate triage questions

- Did the request return HTTP 500 or contain a SQL error in the response? (Indicates the injection may have actually executed.)
- Is the source IP from a known-authorised pentest? (Internal red team, contracted assessor.)
- How many SQLi events from this IP in the last hour? Single probe or sustained attack?
- Was the targeted endpoint a known-vulnerable code path? (Check application security advisories.)
- Has the same source IP also triggered STAR-001/002/003 (recon, brute force)?

---

## 3. Investigation steps

1. Retrieve the full request including all headers and body (nginx + application logs).
2. Examine the response — status code, response time, error messages.
3. Search for all events from the source IP in the last 24 hours across all rules.
4. Identify what SQL was injected — UNION-based suggests data exfiltration intent; blind/time-based suggests reconnaissance/extraction phase.
5. Check application database logs for any unusual queries during the event window.
6. Look up source IP in threat intel (AbuseIPDB, AlienVault OTX).

---

## 4. Containment

**Short-term (automated where possible):**
- Block source IP at the WAF/reverse proxy immediately for 60+ minutes.
- Enable WAF SQLi rule set on the vulnerable endpoint if not already active.

**Long-term:**
- Patch the vulnerable code path — use parameterised queries, ORM bindings, never string concatenation.
- Conduct full code review of the affected endpoint and adjacent endpoints.
- Verify input validation and output encoding throughout the application.
- Consider engaging an external pentest to verify the fix.

---

## 5. Escalation criteria

Escalate immediately to Tier 2 / IR Lead / CISO if:
- Response code 500 with SQL error in body — indicates injection executed.
- Response time anomalously high for time-based blind probes — indicates injection worked.
- Sustained attack (10+ events from same IP over an hour).
- Targeted endpoint accesses sensitive data tables.
- Application/database logs show unusual queries during the event window.

---

## 6. Close-out

Note in the ticket: source IP, full request URL, request body if available, response code/time, SQL pattern matched, application endpoint, threat-intel verdict, containment actions taken, MITRE technique T1190 confirmed. If the vulnerability is confirmed in code, open an engineering ticket immediately with severity tied to the data exposure risk.
