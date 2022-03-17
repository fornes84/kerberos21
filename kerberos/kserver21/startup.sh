#! /bin/bash

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.
cp /opt/docker/kdc.conf /etc/krb5kdc/kdc.conf
cp /opt/docker/kadm5.acl /etc/krb5kdc/kadm5.acl

kdb5_util create -s -P masterkey 
#ADALT??

#kadmin.local -q "addprinc -pw kadmin admin" 
# NO SE SI CAL

for user in kuser{01..03} 
do
  kadmin.local -q "addprinc -pw k$user $user"
done

kadmin.local -q "addprinc -pw kuser01 user01/admin"


#for user in kuser{01..03}
#do
#  kadmin.local -q "addprinc -pw $user $user"
#done


#SERVEIX PER CREAR UN HOST KERBERITZAT QUE PUGUI UTILTIZAR KERBEROS
kadmin.local -q "addprinc -randkey host/ssh.edt.org"


/etc/init.d/krb5-admin-server start
/etc/init.d/krb5-kdc start

#/usr/sbin/krb5kdc
#/usr/sbin/kadmind -nofork

/bin/bash
#AIXO EL JUAN NO HO TE
