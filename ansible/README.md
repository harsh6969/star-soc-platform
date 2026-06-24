# STAR Ansible Automation

This directory contains Ansible playbooks for the STAR project, automating:

1. **Attack simulation** — playbooks that trigger each STAR detection scenario.
2. **Deployment documentation** — playbooks recording how Wazuh agent was installed.

## Usage
cd ~/star-soc-platform/ansible

ansible-playbook -i inventory/hosts.yml playbooks/<playbook-name>.yml
## Playbooks

| File | Purpose | Triggers |
|------|---------|----------|
| `playbooks/01-deploy-wazuh-agent.yml` | Document agent install | (informational) |
| `playbooks/02-attack-ssh-brute-force.yml` | Simulate STAR-001 | Wazuh rule 100100 |
| `playbooks/03-attack-credential-stuffing.yml` | Simulate STAR-002 | Wazuh rule 100200 |
| `playbooks/04-attack-web-brute-force.yml` | Simulate STAR-003 | Wazuh rule 100300 |
| `playbooks/05-attack-sql-injection.yml` | Simulate STAR-004 | Wazuh rule 100410 |
| `playbooks/99-run-all-attacks.yml` | Run all attack scenarios sequentially | All STAR rules |

