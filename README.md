# Jenkins-Setup
This guide will help installing Jenkins on Docker Swarm on 2 Ubuntu 18.04 Machines.
## Install Docker
To run Jenkins on the Ubuntu Hosts, each of the hosts must have docker installed in order for Jenkins to run. This can be done by following [this guide](https://docs.docker.com/install/linux/docker-ce/ubuntu/) or following the steps below:
```
sudo apt-get update
```
```
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
```
sudo apt-key fingerprint 0EBFCD88
```
```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
```
sudo apt-get update
```
```
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

## Initialize Swarm
To make sure that the Jenkins Service Replicates and to make optimal usage of the 2 hosts. We will initiaize the swarm using the following command:
```
sudo docker swarm init
```
This will result in the swarm being initialized. After the initialization the following will appear in the Terminal:
```
Swarm initialized: current node (ID) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token <Docker Swarm Token> \
    <IP Address>:2377
```
Use this command on the second host to join it into the swarm (you might need to use sudo). Now you are almost ready to deploy Jenkins! However you still have to configure some small things.
## Configure Passwordless SSH
On your local machine execute:
```
ssh-keygen -t rsa
```
Copy the public key to the Server you want to authenticate to:
```
ssh-copy-id <username>@<Server IP address>
```
## Clone the GitHub Repository
```
git clone git@github.com:thijsvanloef/Jenkins-Docker.git
```
or
```
git clone https://github.com/thijsvanloef/Jenkins-Docker.git
```
## Deploy the Stack
Find the docker-compose.yml file inside the cloned github repository and run the following:

```
sudo docker stack deploy --compose-file=docker-compose.yml jenkins
```
This will start the building of the image, and automatically exposes your Jenkins instance on [localhost:8080](http://localhost:8080)
## Enable Sync between hosts
Open up the crontab config:
```
crontab -e
```
Add the following lines to the file to sync every 5 minutes:
```
*/5 * * * * rsync -a --delete ~/jenkins <Username>@<IP Address>:~/
*/5 * * * * rsync -a --delete <Username>@<IP Address>:~/jenkins ~/
```
Keep in mind however that some changes can be overwritten using this configuration. See [this Issue](https://github.com/thijsvanloef/Jenkins-Setup/issues/1).

## Jenkins Setup

### Install plugins
Plugins Are already installed when running the image from the docker-compose.yml file.
Please select 
- Create admin account
- Install Docker-Swarm Add-on

## Docker Host Certificate Authentication
In progress