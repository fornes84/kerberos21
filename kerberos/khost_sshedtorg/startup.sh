#! /bin/bash

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.
cp /opt/docker/kdc.conf /etc/krb5kdc/kdc.conf
cp /opt/docker/kadm5.acl /etc/krb5kdc/kadm5.acl
cp /opt/docker/system-auth /etc/pam.d/system-auth

kdb5_util create -s -P masterkey
groupadd local01
groupadd kusers


useradd -g users -G local01 local01
useradd -g users -G local01 local02
useradd -g users -G local01 local03

#usuaris kerberos (sense passwd)(el treuran de kserver)
useradd -g users -G kusers user01
useradd -g users -G kusers user02
useradd -g users -G kusers user03

echo -e "local01\nlocal01" | passwd local01
echo -e "local02\nlocal02" | passwd local02
echo -e "local03\nlocal03" | passwd local03




/bin/bash
