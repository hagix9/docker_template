#!/bin/bash
# Create a CentOS base image for Docker
# From unclejack https://github.com/dotcloud/docker/issues/290
set -e

MIRROR_URL="http://vault.centos.org/6.3/os/x86_64/"
MIRROR_URL_UPDATES="http://vault.centos.org/6.3/updates/x86_64/"
ROOT_PASSWORD=root

rpm -qa |grep epel-release
if [ $? -ne 0 ] ; then
  rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm 
fi
yum install -y febootstrap xz

febootstrap -i bash -i coreutils -i tar -i bzip2 -i gzip -i vim-minimal -i wget -i patch -i diffutils -i iproute -i yum -i centos-release -i openssh-clients -i openssh-server -i ftp -i telnet -i passwd -i sudo centos centos63  $MIRROR_URL -u $MIRROR_URL_UPDATES
touch centos63/etc/resolv.conf
touch centos63/sbin/init
cp -a centos63/etc/skel/.bash* centos63/root
echo "root:$ROOT_PASSWORD" | chroot centos63 chpasswd
chroot centos63 service sshd start 
#chroot centos63 service sshd stop 
chroot centos63 chkconfig sshd on
sed -i.bak 's/UsePAM yes/UsePAM no/' centos63/etc/ssh/sshd_config

tar --numeric-owner -Jcpf centos-63.tar.xz -C centos63 .
\rm -rf centos63
