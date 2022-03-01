# kerberos21

tenim **pràctica1** on hi tenim 2 dockers un amb el kerberos server i l'altre amb keberos client. Els dos tenen Dockerfile per a copiar arxius de configuració.
Només el servidor té un script per basicament crear els usuaris normals i de kerberos (i kerbero admin), executar els dimonis (krb5-admin-server i starkrb5-kdc). 
També farem que el client alhora tingui configurat PAM (concretament dins /etc/pam.d/ common-auth  common-password  common-session)
perquè utilitzi el servidor de kerberos per autentificar els usuaris XXXXX (una seguretat extra). 

PD:Aquí no caldrà EXPORTAR ports ja que tot treballa amb la mateixa xarxa docker 2hisix.

SERVIDOR:
docker run --rm --name kserver.edt.org -h kserver.edt.org --net 2hisix -it balenabalena/kerberos21:kserver

CLIENT:
docker run --rm --name kclient.edt.org -h kclient.edt.org --net 2hisix -it balenabalena/kerberos21:ksclient

    1  apt update
    2  apt install vim nmap procps -y
    3  nmap localhost
    4  apt install krb5-user
    5  cat /etc/krb5.conf
    6  kinit pere # ens logguejem com a per
    7  klist   #mirem que veiem
    8  kadmin.local  #--> entrem a la linea de comandes kerberos-admin
    9  kadmin -p marta #
   10  nmap kserver.edt.org

----------------------------------------------------------------------------------------------------




