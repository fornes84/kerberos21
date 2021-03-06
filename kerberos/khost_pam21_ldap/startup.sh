#! /bin/bash

########### PART LDAP ######################

#useradd -m -s /bin/bash unix01
#useradd -m -s /bin/bash unix02
#useradd -m -s /bin/bash unix03
#echo -e "unix01\nunix01" | passwd unix01
#echo -e "unix02\nunix02" | passwd unix02
#echo -e "unix03\nunix03" | passwd unix03


cp /opt/docker/ldap.conf /etc/ldap/ldap.conf
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf

/usr/sbin/nscd
/usr/sbin/nslcd

########### PART KERBEROS #################

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.

# AIXO D?AQUI ABAIX NO HO PILLO, EXTRET DE CANET

authconfig  --enableshadow --enablelocauthorize --enableldap \
            --ldapserver='ldap.edt.org' --ldapbase='dc=edt,dc=org' \
            --enablekrb5 --krb5kdc='kserver.edt.org' \
            --krb5adminserver='kserver.edt.org' --krb5realm='EDT.ORG' \
            --enablemkhomedir --updateall
            
            
cp /opt/docker/kdc.conf /etc/krb5kdc/kdc.conf   # AQUEST NO CAL, ES DE SERVIDOR ??
cp /opt/docker/kadm5.acl /etc/krb5kdc/kadm5.acl
cp /opt/docker/system-auth /etc/pam.d/system-auth

cp /opt/docker/ssh_config /etc/ssh/ssh_config # pas pendent

kdb5_util create -s -P masterkey
groupadd local01
groupadd kusers
useradd -g users -G local01 local01
useradd -g users -G local01 local02
useradd -g users -G local01 local03

# aquests no tenen passwd pq l'agafaran de kerberos

useradd -g users -G kusers user01
useradd -g users -G kusers user02
useradd -g users -G kusers user03

# COMPROBAR QUE AIXO ESTA BÉ !!:
useradd -g users -G kusers marta
useradd -g users -G kusers pere
useradd -g users -G kusers anna

echo -e "local01\nlocal01" | passwd local01
echo -e "local02\nlocal02" | passwd local02
echo -e "local03\nlocal03" | passwd local03

#/etc/init.d/krb5-admin-server start # DIMONI DE SERVIDOR
#/etc/init.d/krb5-kdc start  #DIMONI DE SERVIDOR

/bin/bash
