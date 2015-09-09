#!/bin/bash

cd /box/mesos-cicd
echo "Bring up docker  registry ... "

sudo docker run -p 5000:5000 -v /box/mesos-cicd/.localdata/registry-stuff:/registry -e STORAGE_PATH=/registry registry &

cd jenkins
docker build -t localhost:5000/reza/myjenkins .
docker push localhost:5000/reza/myjenkins
