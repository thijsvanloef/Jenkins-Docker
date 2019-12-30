# Jenkins-Setup
This guide will help installing Jenkins on Docker Swarm on 2 Ubuntu 18.04 Machines.
## Install Docker
To run Jenkins on the Ubuntu Hosts, each of the hosts must have docker installed in order for Jenkins to run. This can be done by following [this guide](https://docs.docker.com/install/linux/docker-ce/ubuntu/) or run the command below:
```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
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
### Unlock Jenkins
The first step after navtigating to your jenkins instance, is unlocking your instance. This is done by entering the following command on your docker host:
```
sudo docker logs <containerid>
```
This command will output the logs and you will come across something like this:
```
Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

<Long Password String>

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
```
Copy and paste this password into the webform and click Continue.
### Install plugins
The plugins you'll need are already on the image you've pulled from hub.docker.com, so when asked to customize Jenkins please select the option: "Select Plugins to install"
Then at the top of the page click "none" and then Install.
### Create First Admin User
In this form please enter the credentials of the first admin user you will use to initially configure Jenkins.
Then click Save and Continue.
### Instance Configuration
For the final step enter the Jenkins Base URL where your Jenkins Instance will be available from.
When you've entered the Base URL hit Save and Finish.
Now you are ready do use Jenkins.

## Connecting Jenkins To Docker Daemon
### Exposing Docker Daemon
Create a file at /etc/systemd/system/docker.service.d/startup_options.conf with the below contents:
```
# /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376
```
Reload the unit files:
```
sudo systemctl daemon-reload
```
Restart the docker daemon with new startup options:
```
sudo systemctl restart docker.service
```
### Adding New Cloud
