# kerberos21

Tenim **pràctica1+2** on hi tenim 1 docker en el nostre host un amb el kerberos server i un client ( en un altre host) MiniLinux Fedora 32 amb keberos client. El client s'instalarà tot a 'manija'.
El servidor té un script per basicament crear els usuaris normals UNIX i alhora de kerberos (i 1 kerbero admin ?), executar els dimonis (krb5-admin-server i starkrb5-kdc). 
També farem que el client alhora tingui configurat PAM (concretament posnat dins /etc/pam.d/ els fitx --> common-auth  common-password  common-session)
perquè utilitzi el servidor de kerberos per autentificar (buscar a servidor el password que comença per 'k' al host kerberos) (això ho fa el modul pam_krb5) els usuaris locals que no tinguin PASSWORD i alhora es crearà un tiket validant que tenims drets com l'usuari conectat amb kerberos. 

Cal el EXPOSE del dockerfile ?

SERVIDOR:
sudo docker build -t balenabalena/kerberos21:kserver .
sudo docker push balenabalena/kerberos21:kserver
sudo docker run --rm --name kserver.edt.org -h kserver.edt.org -p 749 -p 88 -p 464  -it balenabalena/kerberos21:kserver
(ull no cal --net 2hisix, no ?)

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




