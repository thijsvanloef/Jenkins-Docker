# Pull the image
FROM jenkins/jenkins:2.210
# Become root to pull plugins.txt from github repo
USER root
RUN wget 'https://raw.githubusercontent.com/thijsvanloef/Jenkins-Setup/master/plugins.txt' -O /usr/share/jenkins/ref/plugins.txt
# Install the plugins
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
