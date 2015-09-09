
mkdir app1
 
cd app1

vim app.js

// Load the http module to create an http server.
var http = require('http');

// Configure our HTTP server to respond with Hello World to all requests.
var server = http.createServer(function (request, response) {
  response.writeHead(200, {"Content-Type": "text/plain"});
  response.end("Hello Worldn");
});

// Listen on port 8000, IP defaults to "0.0.0.0"
server.listen(8000);

// Put a friendly message on the terminal
console.log("Server running at http://127.0.0.1:8000/");

vim package.json
{
  "name": "hello-world",
  "description": "hello world",
  "version": "0.0.1",
  "private": true,
  "dependencies": {
    "express": "3.x"
  },
  "scripts": {"start": "node app.js"}
}

vim Dockefile
FROM google/nodejs

WORKDIR /app
ADD package.json /app/
RUN npm install
ADD . /app

EXPOSE 8000
CMD []
ENTRYPOINT ["/nodejs/bin/npm", "start"]

we need to share NFS based synced folders between developer machine and vagrant machine, Mac OSx
by default has the nfsd but for ubunut you need to install it.

$ dpkg -l | grep nfs-kernel-server
Install the required packages...

# apt-get install nfs-kernel-server

for first time  Provisioning :

PRX=on vagrant up --provision

for future re-provisioning use this command
PRX=on vagrant reload --provision

for using nfs synced folder we should assign ip address to the Host vm

vagrant up --provider=docker

vagrant ssh


#Run registry First

docker run -p 5000:5000 -v /box/mesos-cicd/.localdata/registry-stuff:/registry -e STORAGE_PATH=/registry registry


docker build -t localhost:5000/reza/nodejs_app .
docker push localhost:5000/reza/nodejs_app


mkdir ../jenkins
cd ../jenkins


id reza
(999)docker
vi Dockerfile


#FROM jenkins

#MAINTAINER Reza

#USER root
#TODO the group ID for docker group on my Ubuntu is 125, therefore I #can only run docker commands if I have same group id inside.
# Otherwise the socket file is not accessible.
#RUN groupadd -g 999 docker && usermod -a -G docker jenkins
#USER jenkins


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

vim apt.conf
Acquire::socks::proxy "socks://10.44.41.228:1080/";
Acquire::http::proxy "http://10.44.41.228:8080/";
Acquire::https::proxy "http://10.44.41.228:8080/";

vim plugins.txt
scm-api:latest
git-client:latest
git:latest
greenballs:latest



docker build -t localhost:5000/reza/myjenkins .
docker push localhost:5000/reza/myjenkins

curl http://localhost:5000/v1/repositories/reza/myjenkins/tags/latest
curl http://localhost:5000/v1/repositories/reza/nodejs_app/tags/latest

Running  jenkins

first kill
docker kill `(docker ps  | grep  jenkins | cut -c 1-12 )`

run

docker run -t   -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker  -v /home/reza/doj/docker/mesos/jenkins-stuff:/var/jenkins_home  -v  /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0:/lib/x86_64-linux-gnu/libapparmor.so.1 -p 8080:8080 localhost:5000/reza/myjenkins


update docker-compose.yml

registry:
  image: registry
  environment:
    - STORAGE_PATH=/registry
  volumes:
    - registry-stuff:/registry
  ports:
    - "5000:5000"

my_nodejs_app:
  image: localhost:5000/reza/nodejs_app
  ports:
     - "8000:8000"

jenkins:
  image: localhost:5000/reza/myjenkins
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - /usr/bin/docker:/usr/bin/docker
    - /home/reza/doj/docker/mesos/jenkins-stuff:/var/jenkins_home
    - /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0:/lib/x86_64-linux-gnu/libapparmor.so.1

  ports:
    - "8081:8080"


interactive connecting to jenkins
first kill

docker kill `(docker ps  | grep  jenkins | cut -c 1-12 )`

docker run -t -i  -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker  -v /home/reza/doj/docker/mesos/jenkins/data:/var/jenkins_home -v  /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0:/lib/x86_64-linux-gnu/libapparmor.so.1 -p 8080:8080 localhost:5000/reza/myjenkins  bash





==========

put these lines in jenkins

sh build.sh $BUILD_NUMBER
sh push.sh $BUILD_NUMBER


kill all process
 docker kill `(docker ps )| grep tcp|cut -c 1-12`


drwxrwxr-x 9 root root 4096 Sep  1 11:34 jenkins-stuff/
drwxr-xr-x 13 reza reza 4096 Aug 31 16:40 data/


========downgrade docker ==========
How to Install Docker Engine 1.6.2

Download the repository key with:

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

Then setup the repository:

$ sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
$ sudo apt-get update
$ sudo apt-get -y  --force-yes install lxc-docker-1.6.2


Run docker as non-sudo:

$ sudo usermod -a -G docker $USER
$ exit

==downgrade docker-compose

curl -L https://github.com/docker/compose/releases/download/1.3.0/docker-compose-`uname -s`-`uname -m`  > docker-composer

chmod +x docker-compose
mv docker-compose /usr/local/bin


=======docker version 1.8

Client:
 Version:      1.8.1
 API version:  1.20
 Go version:   go1.4.2
 Git commit:   d12ea79
 Built:        Thu Aug 13 02:35:49 UTC 2015
 OS/Arch:      linux/amd64

Server:
 Version:      1.8.1
 API version:  1.20
 Go version:   go1.4.2
 Git commit:   d12ea79
 Built:        Thu Aug 13 02:35:49 UTC 2015
 OS/Arch:      linux/amd64


===============docker version 1.6 ===============


reza@reza-ubuntu:~$ docker version
Client version: 1.6.2
Client API version: 1.18
Go version (client): go1.4.2
Git commit (client): 7c8fca2
OS/Arch (client): linux/amd64
Server version: 1.6.2
Server API version: 1.18
Go version (server): go1.4.2
Git commit (server): 7c8fca2
OS/Arch (server): linux/amd64

=========getting bash from contariner ==================
$ sudo docker exec -i -t 665b4a1e17b6 bash #by ID
or
$ sudo docker exec -i -t loving_heisenberg bash #by Name
$ root@665b4a1e17b6:/#
