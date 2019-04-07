From ubuntu:16.04

Maintainer karim khalfaoui <khalfaoui.karim.42@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

#####################################
## installer java 8
#####################################

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y vim net-tools sudo openssh-server \
    && apt-get -y install software-properties-common \
    && add-apt-repository ppa:webupd8team/java -y \
    && apt-get update -y \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get -y install oracle-java8-installer ssh \
    && apt-get -y remove software-properties-common \
    && apt-get clean autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt \
    /var/lib/dpkg/arch \
    /var/lib/dpkg/available \
    /var/lib/dpkg/cmethopt \
    /var/lib/dpkg/diversions \
    /var/lib/dpkg/diversions-old \
    /var/lib/dpkg/lock \
    /var/lib/dpkg/parts \
    /var/lib/dpkg/statoverride \
    /var/lib/dpkg/status-old \
    /var/lib/dpkg/triggers \
    /var/lib/cache \
    /var/lib/log

##################################### 
# Rajout des modifs bashrc
#####################################

RUN rm -rf ~/.bashrc
ADD ./hadoop_config/.bashrc /root/

#####################################
# changement lieu de travail
#####################################
WORKDIR / 


################################################
# telechargement HADOOP, installation, ssh config 
###############################################
RUN wget http://mirror.ibcp.fr/pub/apache/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz

RUN tar -xzvf hadoop-2.7.7.tar.gz
RUN rm -rf hadoop-2.7.7.tar.gz \
    && mv hadoop-2.7.7 hadoop \ 
    && mv hadoop /usr/local \
    && mkdir -p /usr/local/hadoop_work/hdfs/namesecondary/ \
    && mkdir –p /usr/local/hadoop_work/hdfs/namenode/ \
    && mkdir /usr/local/hadoop_work/hdfs/datanode/ \
    && mkdir -p /usr/local/hadoop_work/yarn/log \
    && mkdir /usr/local/hadoop_work/yarn/local \
    && mkdir -p /var/log/hadoop-yarn/apps \
    && mkdir -p /user/app \
    && mkdir -p /opt/hadoop \
    && rm -rf /etc/ssh/sshd_config

COPY ./hadoop_config/source.sh /
COPY ./ssh/sshd_config /etc/ssh/
RUN  ./source.sh \
     && echo "root:root" | chpasswd \
     &&  mkdir -p /root/.ssh \
     && cd /root/.ssh/ &&  ssh-keygen -t rsa -b \
     4096 -C "root@NameNode" -P "" -f "id_rsa" -q \
     && cat /root/.ssh/id_rsa.pub >>/root/.ssh/authorized_keys \
     && chmod 700 ~/.ssh \
     && chmod 600 ~/.ssh/authorized_keys


#############################################
# modification des fichier de configuration 
# /usr/local/hadoop/etc/hadoop
############################################

RUN rm -rf /usr/local/hadoop/etc/hadoop/hadoop-env.sh \ 
    && rm -rf /usr/local/hadoop/etc/hadoop/core-site.xml \
    && rm -rf /usr/local/hadoop/etc/hadoop/hdfs-site.xml \
    && rm -rf /usr/local/hadoop/etc/hadoop/yarn-site.xml \ 
    && rm -rf /usr/local/hadoop/etc/hadoop/mapred-site.xml.template  

COPY ./hadoop_config/hadoop-env.sh \
     ./hadoop_config/core-site.xml \
     ./hadoop_config/yarn-site.xml \
     ./hadoop_config/mapred-site.xml \
     ./hadoop_config/masters \
     ./hadoop_config/hdfs-site.xml /usr/local/hadoop/etc/hadoop/


##########################################
# création et configuration datanodes 1,2,3 


RUN mkdir -p /usr/local/hadoop_work/hdfs/datanode1 && \
    mkdir -p /usr/local/hadoop_work/hdfs/datanode2 && \
    mkdir -p /usr/local/hadoop_work/hdfs/datanode3


COPY ./hadoop_config/datanode1.xml \
     ./hadoop_config/datanode2.xml \
     ./hadoop_config/datanode3.xml  /usr/local/hadoop/etc/hadoop/


##########################################
# Voir si ca sert de le garder
#WORKDIR /usr/local/hadoop/bin

RUN  /source.sh  
#RUN ./hadoop namenode -format 

#WORKDIR /usr/local/hadoop/sbin


##########################################
EXPOSE 50070 50012 50013 50014
EXPOSE 50010 50020 50075 50090 8020 9000
# Mapred ports
EXPOSE 10020 19888
# Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
# Other ports
EXPOSE 49707 2122
##########################################

EXPOSE 50076 50021 50077 50022 50023 50078
EXPOSE 50099
EXPOSE 1-65535

# au lancement 
# -> service ssh restart && ssh localhost 

#### formattage et lancement namenode
# cd /usr/local/hadoop && ./bin/hadoop namenode -format
# ./bin/hdfs namenode

#### Config datanodes
# faire docker ps -a. Recuperer l'id 
# ouvir 3 fenetres
# docker exec -it <ID-Container>  bash sur les 3 fenetres.

# /usr/local/hadoop/bin/hdfs datanode start

### lancement des datanodes 

# cd /usr/local/hadoop && ./bin/hdfs datanode -conf ./etc/hadoop/datanode1.xml
# cd /usr/local/hadoop && ./bin/hdfs datanode -conf ./etc/hadoop/datanode2.xml
# cd /usr/local/hadoop && ./bin/hdfs datanode -conf ./etc/hadoop/datanode3.xml


#### Aide. Se placer dans dossier hadoop
#./bin/hdfs dfsadmin -report 
#./bin/hdfs fcsk / 
# ./sbin/start-all.sh 

# Changer valeur IP des datanodes  
## ./bin/hdfs datanode -D "dfs.datanode.address=50013" -conf ./etc/hadoop/datanode1.xml
## ./bin/hdfs datanode -D "dfs.datanode.address=50099" -conf ./etc/hadoop/datanode1.xml

