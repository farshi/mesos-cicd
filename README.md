I want to use [Apahce Mesos](http://http://mesos.apache.org/), Marathon and  Jenkins to implement full Continuous Integration and Continuous Delivery (CI/CD)
##Installing specific version of docker and docker-compose in ubuntu

Sometime we need to install down graded version of docker and docker-compose , for example Apache Mesos currently does not work with docker latest version (1.8.1 - when I a writing this guide) and I need to install docker 1.6.2 to sort it out.


Download the repository key by running this command:

```shell
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
$ sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
$ sudo apt-get update
$ sudo apt-get -y  --force-yes install lxc-docker-1.6.2

```
for being able to run docker commands as non-sudo you should run this command:

```shell
$ sudo usermod -a -G docker $USER
```
for testing success of the instalation run `$ docker version` and teh output should be looklike this:
```
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
```
We need to share NFS based synced folders between developer machine and vagrant machine, Mac OSx
by default has the nfsd but for Ububtu you need to install it.

``` shell
$ dpkg -l | grep nfs-kernel-server
```

Install the required packages...

```shell
$ apt-get install nfs-kernel-server
```
for the first time we can run this command to provision vagrant machine :
```shell
PRX=on vagrant up --provision
```
and in the future if you want to run apply provisioning you should use this command  instead of the previous one
```shell
PRX=on vagrant reload --provision
```

for using nfs synced folder we should assign ip address to the Host vm

vagrant up --provider=docker

```shell
$ vagrant ssh
```

#Dockerized jenkins

for building jenkins docker image and pushing it to your running local docker registry follow these steps.

```shell
$ mkdir jenkins
$ cd jenkins
$ vim Dockerfile
```

```yamil
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
```

```shell
$ vim apt.conf
```

```
Acquire::socks::proxy "socks://10.44.41.228:1080/";
Acquire::http::proxy "http://10.44.41.228:8080/";
Acquire::https::proxy "http://10.44.41.228:8080/";
```
```shell
$ vim plugins.txt
```
```yamil
scm-api:latest
git-client:latest
git:latest
greenballs:latest
```

if you don't have docker local registry it's so easy, you can run local docker registry inside docker. it's cool is'nt it , just run this command:

Run registry First

```shell
docker run -p 5000:5000 -v ./registry-stuff:/registry -e STORAGE_PATH=/registry registry
```


Now for building and pushing the jenkins docker image to the local registry , run this commands

```shell
$ docker build -t localhost:5000/reza/myjenkins .
$ docker push localhost:5000/reza/myjenkins
```
for find out the success of pushing you can run this , and then it should return the machine id.
```shell
$ curl http://localhost:5000/v1/repositories/reza/myjenkins/tags/latest
```

#Running  jenkins

for running jenkins docker instance run this

```shell
docker run -t  -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker  -v /home/reza/jenkins-stuff:/var/jenkins_home  -v  /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0:/lib/x86_64-linux-gnu/libapparmor.so.1 -p 8080:8080 localhost:5000/reza/myjenkins
```

 you can use these command to getting bash of docker instances

``` shell getting bash from contariner
$ sudo docker exec -i -t 665b4a1e17b6 bash #by ID
or
$ sudo docker exec -i -t machine-name bash #by Name
$ root@665b4a1e17b6:/#
```


if you want to kill jenkins docker instance and run it again , here is a handy shell command , that save your time. instead running `$ docker ps ` command and c/p jenkins instance id you can run this command.


```jenkins
docker kill `(docker ps  | grep  jenkins | cut -c 1-12 )`
```
for killing all docker instances use this handy command

```shell
 docker kill `(docker ps )| grep tcp|cut -c 1-12`
```
###Runnig jenkins in interactive mode
if you want to ssh to jenkins instance and use the instance in a interactive mode you can use this command

```shell
docker run -t -i -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker  -v /home/reza/jenkins-stuff:/var/jenkins_home  -v  /usr/lib/x86_64-linux-gnu/libapparmor.so.1.1.0:/lib/x86_64-linux-gnu/libapparmor.so.1 -p 8080:8080 localhost:5000/reza/myjenkins bash

```


put these lines in jenkins

sh build.sh $BUILD_NUMBER
sh push.sh $BUILD_NUMBER
