#!/bin/bash
# Switch to root user
sudo su

# Update the instance
yum update -y

# Install Apache HTTP server and wget
yum install -y httpd wget

# Navigate to the Apache document root
cd /var/www/html

# Remove existing files in the document root
rm -rf /var/www/html/*

# Download the website content using wget
wget --mirror --convert-links --adjust-extension --no-parent --quiet -P . https://icp-g-12-project2.netlify.app/

# Move the downloaded site to the document root
mv icp-g-12-project2.netlify.app/* /var/www/html/

# Set permissions to ensure Apache can serve the files
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Enable and start Apache service
systemctl enable httpd
systemctl start httpd
