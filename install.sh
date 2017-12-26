#!/bin/bash -x
export IFS=$'\n'
echo "this command must be executed in root user."
CMDNAME=`basename $0`

if [ $# -eq 0 ]; then
    echo "Usage : ${CMDNAME} [tomcat tar.gz file]"
    exit 1
fi

useradd -s /sbin/nologin tomcat

rm -Rf arc
mkdir arc
curl -O $1 || exit 1
mv *.tar.gz arc/
cd arc/
TGZ=`find . -name *.tar.gz`
echo $TGZ
tar xvfz ${TGZ} || exit 1
rm ${TGZ}
TOMCAT=`ls -1`
echo ${TOMCAT}
mv ${TOMCAT} tomcat9

cp ../usr/local/tomcat9/conf/tomcat9.conf tomcat9/conf/
chown -R tomcat:tomcat tomcat9 || exit 1
cp -Rf tomcat9 /usr/local/ || exit1
cp ../etc/init.d/tomcat9 /etc/init.d/ || exit 1

chkconfig tomcat9 on || exit 1
service tomcat9 restart || exit 1
