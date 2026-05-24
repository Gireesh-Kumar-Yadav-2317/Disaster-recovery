#!/bin/bash

dnf update -y

dnf install -y httpd amazon-cloudwatch-agent

systemctl enable httpd

systemctl start httpd

echo "Disatater rRecovery Resiliency  Test  Server" > /var/www/html/index.html


