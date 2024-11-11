## Base Linux Image for NS3 environment
FROM ubuntu:22.04 as ns3-linux-env

RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until
RUN apt-get update
RUN apt-get install -y \
 wget \
 autoconf \
 bzr \
 unrar \
 build-essential \
 clang \
 valgrind \
 gsl-bin \
 flex \
 bison \
 sqlite \
 sqlite3 \
 libxml2 \
 vtun \
 lxc \
 python3 \
 python3-setuptools \
 cmake \
 libc6-dev \
 libc6-dev-i386 \
 g++-multilib \
 python3-pip
RUN apt-get clean && rm -rf /var/lib/apt

## Base NS3 installation (v3.42) image
FROM ns3-linux-env as ns342-installation
RUN apt-get update && apt-get install -y git

# Create working directory
RUN mkdir -p /usr/ns3
WORKDIR /usr

# Fetch NS-3 source
RUN wget http://www.nsnam.org/release/ns-allinone-3.42.tar.bz2
RUN tar -xjf ns-allinone-3.42.tar.bz2

# Configure and compile NS-3
RUN cd ns-allinone-3.42 && ./build.py

RUN ln -s /usr/ns-allinone-3.42/ns-3.42/ /usr/ns3/

# Cleanup
RUN apt-get clean && \
  apt-get remove -y git && \
  rm -rf /var/lib/apt && \
  rm /usr/ns-allinone-3.42.tar.bz2

  ## NS3 installation (v3.42) with additional modules (LoraWAN & 5G-lena)
FROM ns342-installation as ns342-installation-extended
RUN apt-get update && apt-get install -y git libc6-dev sqlite sqlite3 libsqlite3-dev

# Download LoraWAN module
RUN git clone https://github.com/signetlabdei/lorawan /usr/ns-allinone-3.42/ns-3.42/src/lorawan

# Download 5G-lena module
RUN cd /usr/ns-allinone-3.42/ns-3.42/contrib && \
    git clone https://gitlab.com/cttc-lena/nr.git && \
    cd /usr/ns-allinone-3.42/ns-3.42/contrib/nr && \
    git checkout -b 5g-lena-v3.3.y origin/5g-lena-v3.3.y

# Configure and compile NS-3
RUN cd /usr/ns-allinone-3.42 && ./build.py