#! /bin/bash

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.
cp /opt/docker/kdc.conf /etc/krb5kdc/kdc.conf
cp /opt/docker/kadm5.acl /etc/krb5kdc/kadm5.acl

kdb5_util create -s -P masterkey 
#ADALT??

#kadmin.local -q "addprinc -pw kadmin admin" 
# NO SE SI CAL

kadmin.local -q "addprinc -pw kuser01 user01/admin"
kadmin.local -q "addprinc -pw kuser02 user02"
kadmin.local -q "addprinc -pw kuser03 user03"

#SERVEIX PER CREAR UN HOST KERBERITZAT QUE PUGUI UTILTIZAR KERBEROS
kadmin.local -q "addprinc -randkey host/ssh.edt.org"


/etc/init.d/krb5-admin-server start
/etc/init.d/krb5-kdc start

/bin/bash
