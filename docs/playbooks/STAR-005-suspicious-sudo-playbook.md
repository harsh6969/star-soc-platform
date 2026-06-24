# STAR-005 Incident Response Playbook — Suspicious Sudo Command

**Triggered by:** Wazuh rule 100510 (custom)
**Underlying events:** Wazuh rule 5402 (Successful sudo to ROOT) + STAR command-pattern match
**Log source:** Linux auth.log
**MITRE Tactic:** TA0004 — Privilege Escalation
**MITRE Technique:** T1548.003 — Sudo and Sudo Caching
**Severity:** High (level 10)
**Average MTTR target:** < 10 minutes

---

## 1. What just happened

A user successfully ran a high-risk command via sudo. Examples include reading credential files (/etc/shadow), modifying sudoers, creating or removing accounts, disabling firewalls, or executing suspicious network tooling. None of these are routine for normal users in a banking environment — most legitimate uses come from infrastructure-as-code or change-managed maintenance, both of which should follow a documented process.

This is a high-signal indicator of either an insider threat (malicious or accidental misuse) or a post-compromise attacker who has already gained user access and is escalating to root.

---

## 2. Immediate triage questions

- Who ran the command (`src_user`)? Are they authorised to perform this action?
- Is the host in a documented maintenance window or change window?
- Was the command run interactively or as part of an automated tool / configuration management?
- What was the previous activity from this user in the last 15 minutes?
- Did the user attempt the same command (or related ones) on other hosts?

---

## 3. Investigation steps

1. Pull all events for the source user across all hosts in the last 24 hours.
2. Check whether the user was logged in via SSH from an unusual IP or location.
3. Examine the surrounding commands run via sudo in the same session.
4. Verify whether the command's outcome warrants action — for example, was a new privileged account actually created?
5. Look for follow-on activity that would indicate persistence or lateral movement.

---

## 4. Containment

**Short-term:**
- Suspend the user account immediately if compromise is suspected.
- Terminate the active SSH session.
- Snapshot the host for forensics.

**Long-term:**
- Review and tighten sudoers — least-privilege principle.
- Implement command auditing (e.g., auditd watch rules) for the specific command classes.
- For genuine sysadmin needs, route privileged actions through a privileged access management (PAM) system with approval workflow.

---

## 5. Escalation criteria

Escalate immediately to Tier 2 / IR Lead if:
- The user has no business reason for the command.
- The host runs critical banking services (database, payment, customer data).
- The user account shows other STAR detections in the same window.
- The command was followed by file modifications, network connections, or new processes.

---

## 6. Close-out

Note in the ticket: source user, target host, command run, time, session details (TTY, parent shell), whether action was approved, and confirm MITRE technique T1548.003.
