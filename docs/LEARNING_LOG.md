# STAR Learning Log

## Day 2 - June 3, 2026
- Completed Phase 1 environment: WSL2 + Ubuntu + Git + GitHub + repo
- Created project structure: docs, detections, playbooks, ansible, logs
- Tomorrow: install Docker, then begin Phase 2 (Wazuh)
## Day 2 Evening — Phase 2 Complete
- Wazuh stack (Manager + Indexer + Dashboard) running via Docker
- Agent registered on wazuh-manager-host, status Active
- First detection fired: Rule 5404 (Three failed attempts to run sudo), level 10
- Detection mapped to MITRE T1548.003 — Privilege Escalation + Defense Evasion
- Mapped to PCI DSS 10.2.4/10.2.5, HIPAA 164.312.b, NIST AU.14/AC.7
- Wazuh's SCA automatically ran CIS Ubuntu 24.04 benchmark (score 42)
- Total events ingested today: 299
- Next: Phase 3 — build attack lab (vulnerable target containers + Kali attacker VM)

## Day 2 Late — Phase 3 Complete
- Kali Linux installed as second WSL2 distro (attacker box)
- OWASP Juice Shop deployed as banking-style web target (Docker, port 3000)
- nmap recon scan from Kali → Ubuntu host: found Wazuh (443, 9200, 1514/1515), Juice Shop (3000)
- OBSERVATION: nmap port scan did NOT trigger Wazuh detection (default agent watches logs, not network traffic). Gap to close in Phase 4 with Suricata or iptables logging.
- SSH brute force (hydra) from Kali → Ubuntu (172.28.199.49): 5 wrong passwords
- Wazuh detected: rule 5760 (sshd authentication failed) x5, rule 5503 (PAM user login failed) x4, all on agent wazuh-manager-host
- MITRE: T1110.001 (Password Guessing), tactic TA0006 (Credential Access)
- OBSERVATION: Default correlation rule 5712 did not fire (threshold 8+ attempts not met with only 5). Will author a banking-tuned brute-force rule in Phase 4.
- All four lab containers running cleanly. End-to-end attack-to-detection path validated.

## Day 14 — STAR-003 deployed
- Banking web application login brute force detection (rule 100300, MITRE T1110.001 in web context)
- New architecture: nginx reverse proxy in front of Juice Shop, banking-realistic
- New log source onboarded: nginx access logs via Wazuh agent localfile
- Two-rule chain: 100310 atomic (failed login at /rest/user/login) + 100300 correlation (5+ in 60s)
- Production-style finding: docker cp preserves root:root mode 644 which silently breaks Wazuh rule loading; fix is chown wazuh:wazuh + chmod 640
- Created scripts/deploy-rules.sh to bake the fix into the deployment procedure
- MITRE coverage now: 3 detections, 2 techniques (T1110.001, T1110.004), 2 log sources (Linux auth + nginx web)
- Next: STAR-004 SQL injection OR wrap

## Day 14 — STAR-004 deployed
- Banking web SQL injection detection (rule 100410, MITRE T1190 Exploit Public-Facing Application)
- NEW MITRE TACTIC OPENED: TA0001 Initial Access (was previously only Credential Access)
- Tested with manual curl probes AND sqlmap automated scan
- 17 distinct SQLi patterns caught: UNION-based, tautology, time-based blind (SLEEP, WAITFOR DELAY), boolean-based blind, complex sqlmap evasions
- Single-event detection (no correlation) at level 10 — no legitimate use case for SQLi in banking URLs
- MITRE coverage now: 4 detections, 3 techniques, 2 tactics, 2 log sources
- Deploy script worked flawlessly — chown/chmod baked in, no permission glitch this time
