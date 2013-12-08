#!/bin/bash
# Create a CentOS base image for Docker
# From unclejack https://github.com/dotcloud/docker/issues/290
set -e

MIRROR_URL="http://ftp-srv2.kddilabs.jp/Linux/packages/CentOS/6.5/os/x86_64/"
MIRROR_URL_UPDATES="http://ftp-srv2.kddilabs.jp/Linux/packages/CentOS/6.5/updates/x86_64/"
ROOT_PASSWORD=root

rpm -qa |grep epel-release
if [ $? -ne 0 ] ; then
  rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_65/epel-release-6-8.noarch.rpm 
fi
yum install -y febootstrap xz

febootstrap -i bash -i coreutils -i tar -i bzip2 -i gzip -i vim-minimal -i wget -i patch -i diffutils -i iproute -i yum -i centos-release -i openssh-clients -i openssh-server -i ftp -i telnet -i passwd -i sudo -i rsyslog -i cronie-noanacron centos centos65  $MIRROR_URL -u $MIRROR_URL_UPDATES
touch centos65/etc/resolv.conf
touch centos65/sbin/init
cp -a centos65/etc/skel/.bash* centos65/root
echo "root:$ROOT_PASSWORD" | chroot centos65 chpasswd
chroot centos65 service sshd start 
#chroot centos65 service sshd stop 
chroot centos65 chkconfig sshd on
chroot centos65 chkconfig crond on
chroot centos65 chkconfig sendmail off
chroot centos65 chkconfig iptables off
chroot centos65 chkconfig rsyslog on
sed -i.bak 's/UsePAM yes/UsePAM no/' centos65/etc/ssh/sshd_config

tar --numeric-owner -Jcpf centos-65.tar.xz -C centos65 .
\rm -rf centos65
