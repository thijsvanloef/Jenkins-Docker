# Pull the image
FROM jenkins/jenkins:lts
# Become root to pull plugins.txt from github repo
USER root
RUN apt-get update
RUN apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get update
RUN apt-get install docker-ce-cli
RUN wget 'https://raw.githubusercontent.com/thijsvanloef/Jenkins-Setup/master/plugins.txt' -O /usr/share/jenkins/ref/plugins.txt
# Install the plugins
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt