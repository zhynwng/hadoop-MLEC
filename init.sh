# A simple script that install all the necessary environment and build
# hadoop from source
# The script build Hadoop without using docker, and it uses hadoop 3.3.5


#-------------------------------Install packages--------------------------------
# Open JDK 1.
sudo apt-get update
sudo apt-get -y install openjdk-8-jdk
# Maven
sudo apt-get -y install maven
# Native libraries
sudo apt-get -y install build-essential autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev libsasl2-dev
# GCC 9.3.0
sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get -y install g++-9 gcc-9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9
# CMake 3.19
curl -L https://cmake.org/files/v3.19/cmake-3.19.0.tar.gz > cmake-3.19.0.tar.gz
tar -zxvf cmake-3.19.0.tar.gz && cd cmake-3.19.0
./bootstrap
make -j$(nproc)
sudo make install
# Protocol Buffers 3.7.1 (required to build native code)
curl -L -s -S https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-java-3.7.1.tar.gz -o protobuf-3.7.1.tar.gz
mkdir protobuf-3.7-src
tar xzf protobuf-3.7.1.tar.gz --strip-components 1 -C protobuf-3.7-src && cd protobuf-3.7-src
./configure
make -j$(nproc)
sudo make install
# Boost
curl -L https://sourceforge.net/projects/boost/files/boost/1.72.0/boost_1_72_0.tar.bz2/download > boost_1_72_0.tar.bz2
tar --bzip2 -xf boost_1_72_0.tar.bz2 && cd boost_1_72_0
./bootstrap.sh --prefix=/usr/
./b2 --without-python
sudo ./b2 --without-python install


# Install Docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo ./start-build-env.sh


#------------------------------Build from source--------------------------------
# Build tar (need to run separately)
# sudo mvn package -Pdist -DskipTests -Dtar -Dmaven.javadoc.skip=true

# Run tests on HDFS
# cd hadoop-hdfs-project && sudo mvn package -Pdist -Dtar -Dmaven.javadoc.skip=true