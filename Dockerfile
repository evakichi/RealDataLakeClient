FROM openjdk:17-slim-bullseye

USER root

RUN apt-get update && apt-get install -y ca-certificates
RUN cd /usr/share/ca-certificates && mkdir mylocal && cp -p /etc/ca-certificates.conf /etc/ca-certificates.conf.bak

COPY ./certs/lets-note.lan.ca.crt  /certs/
RUN cd /usr/share/ca-certificates && cp /certs/lets-note.lan.ca.crt mylocal/
RUN echo "mylocal/lets-note.lan.ca.crt" >> /etc/ca-certificates.conf
RUN update-ca-certificates

RUN addgroup --gid 1000 spark && adduser --uid 1000 --gid 1000 spark
RUN mkdir -p /home/spark/spark-events
RUN chown -R spark:spark /home/spark

RUN apt-get update && apt-get -y upgrade && apt-get -y install vim less wget procps iputils-ping curl python3 python3-pip python3-urllib3 tini
RUN pip install minio requests python-dotenv

RUN mkdir -p /opt/ && \
    cd /opt/ && \
    wget https://dlcdn.apache.org/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3-scala2.13.tgz && \
    tar xzvf spark-3.5.5-bin-hadoop3-scala2.13.tgz && \
    rm spark-3.5.5-bin-hadoop3-scala2.13.tgz && \
    wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar xzvf apache-maven-3.9.9-bin.tar.gz && \
    rm apache-maven-3.9.9-bin.tar.gz

ENV PATH=$PATH:/opt/apache-maven-3.9.9/bin:/opt/spark-3.5.5-bin-hadoop3-scala2.13/bin
COPY ./conf/settings.xml /opt/apache-maven-3.9.9/conf/settings.xml

RUN mvn dependency:get -Dartifact=org.apache.iceberg:iceberg-spark-runtime-3.5_2.13:1.8.1 && \ 
    mvn dependency:get -Dartifact=org.apache.iceberg:iceberg-core:1.8.1 && \
    mvn dependency:get -Dartifact=org.apache.iceberg:iceberg-aws:1.8.1 && \
    mvn dependency:get -Dartifact=org.apache.iceberg:iceberg-aws-bundle:1.8.1 && \
    mvn dependency:get -Dartifact=org.postgresql:postgresql:42.7.5

RUN find /root/.m2/ -name \*.jar -exec mv {} /opt/spark-3.5.5-bin-hadoop3-scala2.13/jars/ \; && rm -rf /root/.m2/

ENV SPARK_HOME=/opt/spark-3.5.5-bin-hadoop3-scala2.13/
USER spark
WORKDIR /home/spark/

CMD ["bash"]
