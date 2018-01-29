#!/bin/bash

instance_id="$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"

yum update -y
yum install -y httpd
service httpd start
chkconfig httpd on
echo "<html><body><h1>${pet_name}</h1><h2>$${instance_id}</h2></body></html>" \
     > /var/www/html/index.html
