# Jenkins-Setup
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
Add the following lines to the file:
```
5 * * * * rsync -a ~/jenkins thijs@10.0.1.62:~/
5 * * * * rsync -a thijs@10.0.1.62:~/jenkins ~/
```

## Jenkins Setup
- Install Recommended plugins
- Create admin account
- Install Docker-Swarm Add-on

## Docker Host Certificate Authentication
In progress