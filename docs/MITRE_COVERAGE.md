# STAR — MITRE ATT&CK Coverage Tracker

This document records which MITRE ATT&CK techniques the STAR platform can detect.
Updated as new detections are added.

| STAR ID  | Wazuh Rule | Technique                                          | Tactic                          | Log Source             | Status   |
|----------|------------|----------------------------------------------------|---------------------------------|------------------------|----------|
| STAR-001 | 100100     | T1110.001 — Brute Force: Password Guessing         | TA0006 — Credential Access      | Linux auth.log (SSH)   | Deployed |
| STAR-002 | 100200     | T1110.004 — Brute Force: Credential Stuffing       | TA0006 — Credential Access      | Linux auth.log (SSH)   | Deployed |
| STAR-003 | 100300     | T1110.001 — Brute Force: Password Guessing         | TA0006 — Credential Access      | nginx access (web)     | Deployed |
| STAR-004 | 100410     | T1190 — Exploit Public-Facing Application          | TA0001 — Initial Access         | nginx access (web)     | Deployed |
| STAR-005 | 100510     | T1548.003 — Abuse Elevation Control: Sudo          | TA0004 — Privilege Escalation   | Linux auth.log (sudo)  | Deployed |

## Coverage Summary

- **Detections deployed:** 5
- **MITRE techniques covered:** 4 (T1110.001, T1110.004, T1190, T1548.003)
- **MITRE tactics covered:** 3 (Credential Access, Initial Access, Privilege Escalation)
- **Log sources onboarded:** 2 (Linux auth.log, nginx access log)
