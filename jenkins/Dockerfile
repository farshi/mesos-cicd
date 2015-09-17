FROM jenkins:1.596

USER root
##If you are using http proxy for connecting to the internet 
#  comment out the proxy settings block
### proxy settings block-start

COPY apt.conf /etc/apt/apt.conf
ENV http_proxy http://10.44.41.228:8080
ENV https_proxy http://10.44.41.228:8080
ENV all_proxy 10.44.41.228:1080

###proxy settings block-end

RUN apt-get update  && apt-get install -y sudo  && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
