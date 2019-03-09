# demande de connextion ssh

echo "yes"

ssh localhost

##################################
cd /usr/local/hadoop/sbin
hdfs namenode -format
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
hadoop fs -copyToLocal test3 /usr/local/hadoop


##################################
cd $HADOOP_HOME/share/hadoop/mapreduce

hadoop jar hadoop-mapreduce-examples-2.7.7.jar wordcount ./4300.txt 4300-output

hadoop fs -cat 4300-output/part-r-00000

# hadoop checknative -a
###########################
# hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.7.jar\ -input /4300.txt -output /results -mapper 'python WordCountMapper.py' -reducer 'python WordCountReducer.py'

hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.7.jar -input 50.txt -output /test1 -mapper 'python3 WordCountMapper.py' -reducer 'python3 WordCountReducer.py' -file /usr/local/hadoop/WordCountReducer.py -file /usr/local/hadoop/WordCountMapper.py



