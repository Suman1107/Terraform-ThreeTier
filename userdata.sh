#!/bin/bash
sudo su
sudo apt-get update -y
sudo apt-get install apache2 -y
echo "<h1><b> This is a webserver </b></h1> " /var/www/html/index.html
sudo systemctl start apache2
sudo systemctl enable apache2
