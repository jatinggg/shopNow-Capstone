# Ansible Configuration Management

This directory contains Ansible playbooks and configurations for automating the setup and configuration of infrastructure components.

## Directory Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── inventory/
│   └── hosts               # Static inventory for Jenkins server
├── playbooks/
│   └── jenkins-setup.yml   # Jenkins server configuration playbook
└── README.md              # This file
```

## Prerequisites

- Ansible installed on your local machine (`pip install ansible`)
- SSH key pair for accessing EC2 instances
- EC2 instance(s) running Ubuntu 22.04

## Quick Start

### 1. Update Inventory

Edit `inventory/hosts` and replace with your server details:

```ini
[jenkins_servers]
jenkins-server ansible_host=<YOUR_JENKINS_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem
```

### 2. Test Connection

```bash
ansible jenkins_servers -m ping -i inventory/hosts
```

### 3. Run Playbook

```bash
# Configure Jenkins server with all required tools
ansible-playbook -i inventory/hosts playbooks/jenkins-setup.yml
```

## Playbooks

### jenkins-setup.yml

Installs and configures:
- **Docker** - For containerization
- **AWS CLI** - For AWS resource management
- **kubectl** - For Kubernetes cluster management
- **Terraform** - For infrastructure provisioning
- **Helm** - For Kubernetes package management

**Usage:**
```bash
ansible-playbook -i inventory/hosts playbooks/jenkins-setup.yml

# With verbose output
ansible-playbook -i inventory/hosts playbooks/jenkins-setup.yml -v

# Dry run (check mode)
ansible-playbook -i inventory/hosts playbooks/jenkins-setup.yml --check
```

## Post-Installation Steps

After running the playbooks:

1. **Configure AWS Credentials**:
   ```bash
   ssh ubuntu@<jenkins-ip>
   sudo su - jenkins
   aws configure
   ```

2. **Restart Jenkins** (to apply docker group permissions):
   ```bash
   sudo systemctl restart jenkins
   ```

3. **Verify Installations**:
   ```bash
   docker --version
   aws --version
   kubectl version --client
   terraform version
   helm version
   ```

## Troubleshooting

**Issue: Permission denied (publickey)**
```bash
# Ensure SSH key has correct permissions
chmod 400 ~/.ssh/your-key.pem

# Test SSH connection
ssh -i ~/.ssh/your-key.pem ubuntu@<jenkins-ip>
```

**Issue: Ansible galaxy roles not found**
```bash
# Install required roles
ansible-galaxy install -r requirements.yml
```

**Issue: Sudo password required**
```bash
# Run with --ask-become-pass
ansible-playbook -i inventory/hosts playbooks/jenkins-setup.yml --ask-become-pass
```

## Variables

Key variables in playbooks:
- `docker_version` - Docker version to install
- `kubectl_version` - kubectl version
- `terraform_version` - Terraform version
- `aws_region` - Default AWS region

## Adding More Playbooks

To create additional playbooks:

```bash
# Create new playbook
touch playbooks/your-playbook.yml

# Add tasks following the YAML structure
# Run the playbook
ansible-playbook -i inventory/hosts playbooks/your-playbook.yml
```

## Best Practices

1. **Use variables** for version numbers and configuration
2. **Test with --check** before applying changes
3. **Use tags** for running specific tasks  
4. **Keep playbooks idempotent** (can be run multiple times safely)
5. **Document variables** and expected outcomes

## For Assignment Demonstration

When demonstrating Ansible to evaluators:

1. Show the inventory configuration
2. Run ping test to show connectivity
3. Execute jenkins-setup playbook
4. Show before/after tool versions
5. Document the automation benefits

---

**Note**: This automation demonstrates Infrastructure as Code principles and configuration management, meeting Sprint 3 requirements of the capstone project.
