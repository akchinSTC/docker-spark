# This is a fork from https://hub.docker.com/r/sequenceiq/spark/  
# This docker support Spark 2

FROM sequenceiq/hadoop-docker:2.7.1
MAINTAINER Asghar Ghorbani [https://de.linkedin.com/in/aghorbani]

# Install Spark 2
ENV SPARK_HOME /usr/local/spark
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz | tar -xz -C /usr/local/ && \
    cd /usr/local && \
    ln -s spark-2.0.2-bin-hadoop2.7 spark && \
    mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

RUN $BOOTSTRAP && \
    $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && \
    $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-2.0.2-bin-hadoop2.7/jars /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

