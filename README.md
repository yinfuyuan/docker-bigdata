# Docker apache

This is a project created to build a apache large data cluster.

The services provided include but not limited to **hadoop** **hbase** **kafka** and **zookeeper**.

You can run this software on linux or windows or mac, recommending use of x86_64 linux platforms.

If you run on a mac, please reference https://docs.docker.com/docker-for-mac/osxfs/#namespaces share you mount directory.

## Dependencies

git version 1.8.3.1 or higher

docker version 17.09.0-ce or higher

docker-compose version 1.16.1 or higher

## Get installed
    
    $ git clone https://github.com/yinfuyuan/docker-apache.git

## services
    
    You can start all the services using the following command:
    
    #docker-compose up -d
    
    If you want to start a service separately, start the service that the service depends on.
    Here are some examples of starting and stopping services:
        
    up
    #docker-compose [-f docker-compose-SERVICE.yml] up -d
    start
    #docker-compose [-f docker-compose-SERVICE.yml] start
    stop
    #docker-compose [-f docker-compose-SERVICE.yml] stop
    restart
    #docker-compose [-f docker-compose-SERVICE.yml] restart
    down
    #docker-compose [-f docker-compose-SERVICE.yml] down

### zookeeper
    
    The service from the zookeeper official image
    version 3.4.12
    [image](https://hub.docker.com/_/zookeeper/)
    [Dockerfile](https://github.com/31z4/zookeeper-docker/blob/0e558d7a6df4031a6be7c1df4ba1e2367666d004/3.4.12/Dockerfile)
    
### hadoop
    
    The service from the hadoop image, if you use docker-compose-hadoop.yml for the first time,it automatically builds the image.
    You can comment out the build option to direct to use image.
    version 2.7.6
    [image](https://hub.docker.com/r/yinfuyuan/hadoop/)
    [Dockerfile](https://github.com/yinfuyuan/docker-apache/blob/master/services/hadoop/2.7/Dockerfile)
    
    After you up the service you can use the host machine ip:50070 view the
    hdfs and use the host machine ip:8088 view yarn
    
### hbase
    
**The service depends on zookeeper service, Start the zookeeper service before starting.**

    The service from the hbase image, if you use docker-compose-hbase.yml for the first time,it automatically builds the image.
    You can comment out the build option to direct to use image.
    version 2.0.0
    [image](https://hub.docker.com/r/yinfuyuan/hbase/)
    [Dockerfile](https://github.com/yinfuyuan/docker-apache/blob/master/services/hbase/2.0/Dockerfile)
    
    After you up the service you can use the host machine ip:16010 view the hbase.
    
### kafka
    
**The service depends on zookeeper service, Start the zookeeper service before starting.**
    
    The service from the kafak image, if you use docker-compose-kafka.yml for the first time,it automatically builds the image.
    You can comment out the build option to direct to use image.
    version 1.1.0
    [image](https://hub.docker.com/r/yinfuyuan/kafka/)
    [Dockerfile](https://github.com/yinfuyuan/docker-apache/blob/master/services/kafka/Dockerfile)