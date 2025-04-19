#!/bin/bash

# Fetch public IP from Terraform output
IP=$(terraform output -raw webserver_public_ip)

# First-time SSH to accept host key
ssh -o StrictHostKeyChecking=no -i ~/.ssh/my-key ec2-user@$IP "echo Host key accepted"

# Create inventory.ini
cat <<EOF > inventory.ini
[webservers]
$IP ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/my-key
EOF

echo "inventory.ini created with IP: $IP"
