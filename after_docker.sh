## pour lancer le word count
# les lignes ci dessous servent à titre d'exemple
# Pour lancer le word count


# lancement de dfs et yarn


start-dfs.sh
start-yarn.sh

##################################

hadoop dfs -mkdir -p /usr/local/hadoop/files

cd /usr/local/hadoop/files
wget http://www.gutenberg.org/files/4300/4300-0.txt
mv 4300-0.txt 4300.txt
cat 4300.txt | head -50


###########

hadoop dfs -copyFromLocal /usr/local/hadoop/files/4300.txt 4300.txt
#hadoop fs -copyToLocal test3 /usr/local/hadoop


##################################
#cd $HADOOP_HOME/share/hadoop/mapreduce

hadoop jar hadoop-mapreduce-examples-2.7.7.jar wordcount ./4300.txt 4300-output

hadoop fs -cat 4300-output/part-r-00000

 hadoop checknative -a


###########################
# test avec le nouveau

#hadoop jar $HS -files $PF/WordCountReducer.py,$PF/WordCountMapper.py  -mapper 'python3 WordCountMapper.py' -reducer 'python3 WordCountReducer.py'  -input 50.txt -output /rellll

#hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.7.jar -files /usr/local/hadoop/MapReduce/tf-idf/WordCountReducer.py,WordCountMapper.py  -mapper 'python3 WordCountMapper.py' -reducer 'python3 WordCountReducer.py'  -input 50.txt -output /rel



###########################
## normal 
# hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.7.jar wordcount ./50.txt 50-out

# avec le word count de base
## hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.7.jar  -mapper 'python3 WordCountMapper.py' -reducer 'python3 WordCountReducer.py' -file /usr/local/hadoop/WordCountMapper.py -file /usr/local/hadoop/WordCountReducer.py -input 50.txt -output /res 

# hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.7.jar -files WordCountReducer.py,WordCountMapper.py  -mapper 'python3 WordCountMapper.py' -reducer 'python3 WordCountReducer.py'  -input 50.txt -output /re
############################
#docker run -it --rm -h NameNode --add-host Namenode:127.0.1.1 --name karimh1 -p 50070:50070 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 50090:50090 -p 8020:8020 -p 9000:9000 -p 10020:10020 -p 19888:19888 -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 8088:8088 -p 49707:49707 -p 2122:212
