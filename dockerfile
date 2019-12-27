FROM jenkins/jenkins:lts
RUN wget 'https://raw.githubusercontent.com/thijsvanloef/Jenkins-Setup/master/plugins.txt' -O plugins.txt
RUN /usr/local/bin/install-plugins.sh plugins.txt