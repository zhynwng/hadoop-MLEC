#-----------------------------Build Node clusters-------------------------------
# Install packages for Node cluster
sudo apt-get install ssh
sudo apt-get install pdsh

# Copy and unpack Hadoop built from source
cp hadoop-dist/target/hadoop-3.3.5.tar.gz ~
cd
tar xzf hadoop-3.3.5.tar.gz
rm hadoop-3.3.5.tar.gz
mv hadoop-3.3.5 hadoop
echo "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> hadoop/etc/hadoop/hadoop-env.sh 

# Standalone operation 
# mkdir input
# cp etc/hadoop/*.xml input
# bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.5.jar grep input output 'dfs[a-z.]+'
# cat output/*

#-------------------------Set up environment------------------------------------
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
export PDSH_RCMD_TYPE=ssh
#sudo chown cc:cc -R /zpool