FROM jenkins/jenkins:lts
USER root
RUN wget 'https://raw.githubusercontent.com/thijsvanloef/Jenkins-Setup/master/plugins.txt' -O /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt