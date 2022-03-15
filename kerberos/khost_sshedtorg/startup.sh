#! /bin/bash

#PART KERBEROS
cp /opt/docker/krb5.conf /etc/krb5.conf
# Sobreescrivim els fitxers per els nostres.
#cp /opt/docker/system-auth /etc/pam.d/system-auth

cp /opt/docker/common-auth /etc/pam.d/common-auth
#cp /opt/docker/common-session /etc/pam.d/common-session
cp /opt/docker/common-account /etc/pam.d/common-account
cp /opt/docker/common-password /etc/pam.d/common-password

groupadd local01
groupadd kusers

useradd -g users -G local01 local01
useradd -g users -G local01 local02
useradd -g users -G local01 local03

echo -e "local01\nlocal01\n" | passwd local01
echo -e "local02\nlocal02\n" | passwd local02
echo -e "local03\nlocal03\n" | passwd local03

#usuaris kerberos (sense passwd)(el treuran de kserver)

useradd -g users -G kusers user01
useradd -g users -G kusers user02
useradd -g users -G kusers user03


# PART SERVIDOR SSH
cp /opt/docker/sshd_conf /etc/ssh/sshd_conf
mkdir -p /run/sshd
/usr/sbin/sshd -D

#/bin/bash
