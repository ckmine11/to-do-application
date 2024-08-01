#! /bin/bash
cd /var/lib/jenkins/workspace/to-do-application/
#sudo su - jenkins -s/bin/bash
#docker logout   harbor.cluster.com/sample-project
sudo docker login -u admin --password root harbor.cluster.com
  sudo docker image build -t  $JOB_NAME:v1.$BUILD_ID .
sudo docker image tag $JOB_NAME:v1.$BUILD_ID harbor.cluster.com/to-do-application/$JOB_NAME:v1.$BUILD_ID
sudo docker image tag $JOB_NAME:v1.$BUILD_ID harbor.cluster.com/to-do-application/$JOB_NAME:latest
sudo docker image push harbor.cluster.com/to-do-application/$JOB_NAME:v1.$BUILD_ID
sudo docker  push harbor.cluster.com/to-do-application/$JOB_NAME:latest
 #docker image rmi $JOB_NAME:v1.$BUILD_ID  harbor.cluster.com/sample-project/$JOB_NAME:v1.$BUILD_ID   harbor.cluster.com/sample-project/$JOB_NAME:latest 
