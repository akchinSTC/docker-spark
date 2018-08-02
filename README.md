Apache Spark on Docker
==========


This repository contains a Docker file to build a Docker image with Apache Spark. 

This is a fork form [Spark](https://github.com/sequenceiq/docker-spark) 1.6.0 docker file of SequenceIQ.

This Docker image depends on [Hadoop Docker](https://github.com/sequenceiq/hadoop-docker) image from SequenceIQ, available at the SequenceIQ [GitHub](https://github.com/sequenceiq) page.

## Pull the image from Docker Repository
```
docker pull aghorbani/spark:2.1.0
```

## Building the image
```
docker build --rm -t aghorbani/spark:2.1.0 .
```

## Running the image

* if using boot2docker make sure your VM has more than 2GB memory
* in your /etc/hosts file add $(boot2docker ip) as host 'sandbox' to make it easier to access your sandbox UI
* open yarn UI ports when running container
```
docker run -it -p 8088:8088 -p 8042:8042 -p 4040:4040 -h sandbox aghorbani/spark:2.1.0 bash
```
or
```
docker run -d -h sandbox aghorbani/spark:2.1.0 -d
```

## Versions
```
Hadoop 2.7.0 and Apache Spark v2.1.0 on Centos
```

## Testing

There are two deploy modes that can be used to launch Spark applications on YARN.

### YARN-client mode

In yarn-client mode, the driver runs in the client process, and the application master is only used for requesting resources from YARN.

```
# run the spark shell
spark-shell \
--master yarn-client \
--driver-memory 1g \
--executor-memory 1g \
--executor-cores 1


# execute the the following command which should return 1000
scala> sc.parallelize(1 to 1000).count()
```
### YARN-cluster mode

In yarn-cluster mode, the Spark driver runs inside an application master process which is managed by YARN on the cluster, and the client can go away after initiating the application.

Estimating Pi (yarn-cluster mode):

```
# execute the the following command which should write the "Pi is roughly 3.1418" into the logs
# note you must specify --files argument in cluster mode to enable metrics
spark-submit \
--class org.apache.spark.examples.SparkPi \
--files $SPARK_HOME/conf/metrics.properties \
--master yarn \
--deploy-mode cluster \
--executor-memory 1G \
--num-executors 2 \
$SPARK_HOME/examples/jars/spark-examples_2.11-2.1.0.jar
```

Estimating Pi (yarn-client mode):

```
# execute the the following command which should print the "Pi is roughly 3.1418" to the screen
spark-submit \
--class org.apache.spark.examples.SparkPi \
--master yarn \
--deploy-mode client \
--executor-memory 1G \
--num-executors 2 \
$SPARK_HOME/examples/jars/spark-examples_2.11-2.1.0.jar 
```

### Submitting from the outside of the container
To use Spark from outside of the container it is necessary to set the YARN_CONF_DIR environment variable to directory with a configuration appropriate for the docker. The repository contains such configuration in the yarn-remote-client directory.

```
export YARN_CONF_DIR="`pwd`/yarn-remote-client"
```

Docker's HDFS can be accessed only by root. When submitting Spark applications from outside of the cluster, and from a user different than root, it is necessary to configure the HADOOP_USER_NAME variable so that root user is used.

```
export HADOOP_USER_NAME=root
```
