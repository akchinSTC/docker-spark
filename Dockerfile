# This is a fork from https://hub.docker.com/r/sequenceiq/spark/  
# This docker support Spark 2

FROM sequenceiq/hadoop-docker:2.7.1
MAINTAINER Asghar Ghorbani [https://de.linkedin.com/in/aghorbani]

ENV SPARK_VER 2.1.0

# Install Spark
ENV SPARK_HOME /usr/local/spark
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VER}-bin-hadoop2.7.tgz | tar -xz -C /usr/local/ && \
    cd /usr/local && \
    ln -s spark-${SPARK_VER}-bin-hadoop2.7 spark && \
    mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

RUN $BOOTSTRAP && \
    $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && \
    $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-${SPARK_VER}-bin-hadoop2.7/jars /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin

# Fix yarn vmem error (see this: https://a-ghorbani.github.io/2016/12/23/spark-on-yarn-and-java-8-and-virtual-memory-error)
COPY yarn-vmem-fix.xml yarn-vmem-fix.xml
RUN sed -i '/<configuration>/r yarn-vmem-fix.xml'  $YARN_CONF_DIR/yarn-site.xml && \
    rm yarn-vmem-fix.xml

# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]

