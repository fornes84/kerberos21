#! /bin/bash

#PART SSH

cp /opt/docker/sshd_conf /etc/ssh/sshd_conf
mkdir /run/sshd
/usr/sbin/sshd -D


#PART KERBEROS

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.
cp /opt/docker/kdc.conf /etc/krb5kdc/kdc.conf
cp /opt/docker/kadm5.acl /etc/krb5kdc/kadm5.acl

kdb5_util create -s -P masterkey
kadmin.local -q "addprinc -pw kalpaca alpaca"
kadmin.local -q "addprinc -pw kpere pere"
kadmin.local -q "addprinc -pw kmarta marta"
kadmin.local -q "addprinc -pw kanna anna"

kadmin.local -q "addprinc -pw kuser01 user01"
kadmin.local -q "addprinc -pw kuser02 user02"
kadmin.local -q "addprinc -pw kuser03 user03"

/etc/init.d/krb5-admin-server start
/etc/init.d/krb5-kdc start

/bin/bash
