# Jenkins-Setup
This guide will help installing Jenkins on Docker Swarm on 2 Ubuntu 18.04 Machines.
## Configure Passwordless SSH
On your local machine execute:
```
ssh-keygen -t rsa
```
Copy the public key to the Server you want to authenticate to:
```
ssh-copy-id <username>@<Server IP address>
```

## Deploy the Stack
Download the Docker-Compose.yml file

```
sudo docker stack deploy --compose-file=docker-compose.yml jenkins
```

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
- Install Recommended plugins
- Create admin account
- Install Docker-Swarm Add-on

## Docker Host Certificate Authentication
In progress