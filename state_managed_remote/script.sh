#!/bin/bash
# This script will install nginx on the EC2 instance
sudo apt update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
# Create a simple HTML file to verify the installation

echo "<h1>Hello from Terraform!</h1>" | sudo tee /var/www/html/index.html
