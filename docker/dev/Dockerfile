FROM ubuntu:18.04

RUN sed -i 's/archive\.ubuntu/tw\.archive\.ubuntu/g' /etc/apt/sources.list
RUN apt-get update
#######################################################################
#Install base package
#######################################################################
RUN apt-get install -y \
        sudo openssh-server make net-tools \
        iputils-ping tree vim samba git netcat \
        valgrind cmake rsyslog cifs-utils\
        autoconf libtool pkg-config git usbutils udev

#######################################################################
#  Install packages for run 32 bit command
#######################################################################
RUN apt-get install -y lib32ncurses5 lib32z1 gawk

#######################################################################
#  Install packages for qemu env
#######################################################################
RUN apt-get install -y zlib1g-dev libglib2.0-dev qemu

#######################################################################
# Install python main package
#######################################################################
#RUN apt-get install -y \
#        python python-pip

#######################################################################
# Install csgfs-dev package
#######################################################################
#RUN apt-get install -y \
#        build-essential libfuse-dev manpages-posix-dev manpages-dev \
#        libconfig-dev fuse socat lsb-release libcurl4-openssl-dev \
#        libxml2-dev libpam0g-dev \
#        libjson-glib-1.0-0 libjson-glib-1.0-common libjson-glib-dev \
#        libssl-dev libssl1.0.0 libssl1.1

#######################################################################
#  Install packages for web
#######################################################################
#RUN apt-get install -y python3 python3-pip sqlite3 \
#        libsqlite3-dev build-essential libssl-dev libffi-dev python-dev
#RUN LC_ALL=C pip3 install --exists-action w Flask pysqlite3 psutil netifaces \
#        contextvars requests pyopenssl urllib3 certifi configobj

RUN apt-get clean

#######################################################################
# Install python internal packages
#######################################################################
#RUN pip install requests paramiko

RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
