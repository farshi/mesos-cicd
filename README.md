

###Practice Immutable Deployments 

In this project I am going to show how you can simply use [Apahce Mesos](http://http://mesos.apache.org/), [Marathon](https://github.com/mesosphere/marathon) and  [Jenkins](https://jenkins-ci.org/) to implement full Continuous Integration and Continuous Delivery (CI/CD). In this project I have useed vagrant which will automatically will install docker and docker-compose and by providing docker-compose.yml it will install and configuer  Jenkins , Mesos Master/Slave , Marathon and Zookeeper inside docker containers.



###Requirements

1.  Install [Virtual Box] (https://www.virtualbox.org/wiki/Downloads)
2.  Install [Vagrant] (https://www.vagrantup.com/)
3.  Install Vagrant [Docker Compose pluging] (https://github.com/leighmcculloch/vagrant-docker-compose)
4.  Fetch the app1 code from https://github.com/farshi/app1 

###How to Run the code

first fetch the mesos-cicd and app1 from the github repos:
```shell
$ git clone https://github.com/farshi/mesos-cicd.git`
$ git clone  https://github.com/farshi/app1`
```
and then

```shell
$ cd mesos-cicd
$ vagrant up
```
###Behind the proxy?
If you are using http proxy server , then you need to comment out proxy settings blocks in these files

- mesos-cicd\Vagrantfile
- mesos-cicd\Jenkins\Dockerfile

and then run  `PRX=on vagrant up`
