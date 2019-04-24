#!/bin/bash
sleep 10
sudo apt-get update -y
echo "================INSTALL JAVA==================="
sleep 10
sudo apt-get install -y openjdk-8-jre
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
echo "================INSTALL JENKINS================"
sudo apt-get install -y jenkins
