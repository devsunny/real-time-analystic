#!/bin/sh

ZOOKEEPER="zookeeper-3.3.5"
ZEROMQ="zeromq-3.2.4"
STORM="storm-0.8.1"


echo "Downloading Apache Zoopkeeper"
if [ ! -e "$ZOOKEEPER.tar.gz" ]; then
wget "http://psg.mtu.edu/pub/apache/zookeeper/$ZOOKEEPER/$ZOOKEEPER.tar.gz"
fi

echo "Downloading 0MQ - $ZEROMQ"
if [ ! -e "$ZEROMQ.tar.gz" ]; then
wget http://download.zeromq.org/$ZEROMQ.tar.gz
fi


echo "Downloading JZMQ from github"
if [ ! -e "jzmq" ]; then
git clone https://github.com/zeromq/jzmq.git
fi

yum install -y libtool libuuid libuuid-devel gcc-c++ make


JAVAC=`which javac`
JAR=`which jar`
JAVA=`which java`
JAVAHOME=`echo -n $JAVA_HOME`
PYTHON=`which python`

if [ "x$PYTHON" = "x" ]; then
echo "Please install python 2.6.6"
exit 1
else
PYTHONVER=`python -c 'import sys; print(sys.version_info)'`
echo "Installed Python version is $PYTHONVER" 
fi 

if [ "x$JAVAHOME" = "x" ]; then
echo "JAVA HOME Environment was not set"
exit 1
fi 

if [ "x$JAVA" = "x" ]; then
echo "java command is not in search path"
exit 1
fi 

if [ "x$JAVAC" = "x" ]; then
echo "javac command is not in search path"
exit 1
fi 

if [ "x$JAR" = "x" ]; then
echo "jar command is not in search path"
exit 1
fi 


if [ ! -e "$ZOOKEEPER" ]; then
tar -xzf "$ZOOKEEPER.tar.gz"
fi

if [ ! -e "$ZEROMQ" ]; then
tar -xzf $ZEROMQ.tar.gz
fi



BASEDIR=`pwd`

if [ ! -e "/usr/local/lib/libzmq.so" ]; then
cd $ZEROMQ
./configure 
make 
make install
cd "$BASEDIR"
fi

if [ ! -e "/usr/local/share/java/zmq.jar" ]; then
cd jzmq
./autogen.sh
./configure 
make 
make install
cd "$BASEDIR"
fi

ldconfig

cd "$ZOOKEEPER"
if [ ! -e "conf/zoo.cfg" ]; then
cp conf/zoo_sample.cfg conf/zoo.cfg
fi


echo "setting up storm now"


if [ ! -e "$STORM.zip" ]; then
wget https://github.com/downloads/nathanmarz/storm/$STORM.zip
fi

if [ ! -e "$STORM" ]; then
unzip $STORM.zip
fi

#bin/zkServer.sh start
if [ ! -e "/tmp/storm" ]; then
 mkdir /tmp/storm
fi

echo "storm.local.dir: \"/tmp/storm\"" >"$STORM/conf/storm.yaml"
echo "storm.zookeeper.servers:" >>"$STORM/conf/storm.yaml"
echo "     - \"localhost\"" >>"$STORM/conf/storm.yaml"
echo "nimbus.host: \"localhost\"" >>"$STORM/conf/storm.yaml"
cat "$STORM/conf/storm.yaml"

#cd "$ZOOKEEPER/bin"
#./zkServer.sh start

cd "$BASEDIR"

#cd "$STORM/bin"
#nohup ./storm nimbus &
#nohup ./storm supervisor &
#nohup ./storm ui &
#firefox http://localhost:8080/ &
















