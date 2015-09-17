In this project I am going to show how you can simply use [Apahce Mesos](http://http://mesos.apache.org/), Marathon and  Jenkins to implement full Continuous Integration and Continuous Delivery (CI/CD).

###Requirements

1. Install Vagrant
2. Install Virtual Box

###How to Run the code

first fetch the code from this repo:
`git clone https://github.com/farshi/mesos-cicd.git`

and then

```shell
$ cd mesos-cicd
$ vagrant up
```
###Behind the proxy?
If you are using http proxy server , then you need to comment out proxy settings blocks in these files

- mesos-cicd\Vagrantfile
- mesos-cicd\Jenkins\Dockerfile
