FROM jenkins:1.596

USER root
COPY apt.conf /etc/apt/apt.conf

ENV http_proxy http://10.44.41.228:8080
ENV https_proxy http://10.44.41.228:8080
ENV all_proxy 10.44.41.228:1080

RUN apt-get update  && apt-get install -y sudo  && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
