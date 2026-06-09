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
