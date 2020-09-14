# demo

1) Deploy K8s cluster to deploy our services

2) Deploy the Jenkins/Ansible Server in AWS to create VM's
Note: Manual steps required to configure Ansible/Jenkins.Below are the steps..
yum install python
yum install python-pip
pip install ansible
yum install docker
service docker start

yum install java-1.8*
modify .bash_profile to set env variable to pick JAVA_HOME path
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum -y install jenkins

#### Create Jenkins pipeline by making use of shell executable by doing following step
3) Run Ansible Playbook in this repo to create/build and push docker image by creating a job in jenkins
## Create post build actions to run the below script using jenkins
4) Run postk8s.sh

