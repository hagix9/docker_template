#!/bin/bash
# Create a CentOS base image for Docker
# From unclejack https://github.com/dotcloud/docker/issues/290
set -e

MIRROR_URL="http://vault.centos.org/6.0/os/x86_64/"
MIRROR_URL_UPDATES="http://vault.centos.org/6.0/updates/x86_64/"

yum install -y febootstrap xz

febootstrap -i bash -i coreutils -i tar -i bzip2 -i gzip -i vim-minimal -i wget -i patch -i diffutils -i iproute -i yum -i centos-release centos centos60  $MIRROR_URL -u $MIRROR_URL_UPDATES
touch centos60/etc/resolv.conf
touch centos60/sbin/init

tar --numeric-owner -Jcpf centos-60.tar.xz -C centos60 .
