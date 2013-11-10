#!/bin/bash
# Create a CentOS base image for Docker
# From unclejack https://github.com/dotcloud/docker/issues/290
set -e

MIRROR_URL="http://vault.centos.org/6.0/os/x86_64/"
MIRROR_URL_UPDATES="http://vault.centos.org/6.0/updates/x86_64/"
ROOT_PASSWORD=root

rpm -qa |grep epel-release
if [ $? -ne 0 ] ; then
  rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm 
fi
yum install -y febootstrap xz

febootstrap -i bash -i coreutils -i tar -i bzip2 -i gzip -i vim-minimal -i wget -i patch -i diffutils -i iproute -i yum -i centos-release -i openssh-clients -i openssh-server -i ftp -i telnet -i passwd -i sudo centos centos60  $MIRROR_URL -u $MIRROR_URL_UPDATES
touch centos60/etc/resolv.conf
touch centos60/sbin/init
cp -a centos60/etc/skel/.bash* centos60/root
echo "root:$ROOT_PASSWORD" | chroot centos60 chpasswd
chroot centos60 service sshd start 
#chroot centos60 service sshd stop 
chroot centos60 chkconfig sshd on
sed -i.bak 's/UsePAM yes/UsePAM no/' centos60/etc/ssh/sshd_config

tar --numeric-owner -Jcpf centos-60.tar.xz -C centos60 .
\rm -rf centos60
