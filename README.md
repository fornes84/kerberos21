# kerberos21

Tenim **pràctica1+2** on hi tenim 1 docker en el nostre host un amb el kerberos server i un client ( en un altre host) MiniLinux Fedora 32 amb keberos client. El client s'instalarà tot a 'manija'.  

El servidor té un script per basicament crear els usuaris normals UNIX i alhora de kerberos (i 1 kerbero admin ?), executar els dimonis (krb5-admin-server i starkrb5-kdc).   

També farem que el client alhora tingui configurat PAM (concretament posnat dins /etc/pam.d/ els fitx --> common-auth  common-password  common-session)
perquè utilitzi el servidor de kerberos per autentificar (buscar a servidor el password que comença per 'k' al host kerberos) (això ho fa el modul pam_krb5) els usuaris locals que no tinguin PASSWORD i alhora es crearà un tiket validant que tenims drets com l'usuari conectat amb kerberos. 
 
389 --> LDAP (NO ESTA PQ EL SERVIDOR ESTA EN UN ALTRE DOCKER)
2200 --> SSH

 
Cal el EXPOSE del dockerfile --> si. 
  
SERVIDOR:    

sudo docker build -t balenabalena/kerberos21:kserver .  

sudo docker push balenabalena/kerberos21:kserver  

sudo docker run --rm --name kserver.edt.org -h kserver.edt.org -p 749:749 -p 88:88 -p 464:464 -it balenabalena/kerberos21:kserver  
(ull no cal --net 2hisix)  

CLIENT:  
 (li hem afeigt client ssh configurat per propagar tiquets keberos)
  
 sudo docker build -t balenabalena/kerberos21:khost . 
 
 sudo docker push balenabalena/kerberos21:khost

 docker run --rm --name khost.edt.org -h khost.edt.org -it balenabalena/kerberos21:kshost  

    1  apt update
    2  apt install vim nmap procps -y
    3  nmap localhost
    4  apt install krb5-user
    5  cat /etc/krb5.conf
    6  kinit pere # ens logguejem com a per
    7  klist   #mirem que veiem
    8  kadmin.local  #--> entrem a la linea de comandes kerberos-admin
    9  kadmin -p marta
    10  nmap kserver.edt.org


**RECORDAR POSAR EN EL /ETC/HOST DEL HOST CLIENT AMB LES IPS CORRESPONENTS D'AMAZON PQ S?APIGA RESOLDRE EL NOM kserver.edt.org!!!!!!**  


PROVES AL HOST CLIENT (MINI LINIUX) (CLIENT FINAL):

kinit pere 
klist --> veure si hi ha algun tiket.

(essent local01 usuari local)
su local01 --> i que demani password kerberos


----------------------------------------------------------------------------------------------------

CLIENT khost_sshedtorg

CREEM UN ALTRE DOCKER CLIENT AMB KERVEROS ACCESSIBLE VIA SSH (TINDRA SERVIDOR SSH)
(EL CLIENT FINAL ES CONECTARA VIA SSH AMB AQUEST UTILITZANT UN USUARI KERBEROS
EX:   guest@i22: ssh user01@ssh.edt.org (user01 es un usuari kerveros)
TAMBE TINDRA VALIDACIO PAM PER INDICAR QUE HA DE BUSCAR A KERBEROS SERVER EL PASSWORD

FER MANUALMENT:

	- MODFICICACIO /etc/hosts (mirar guia practica)
 
	- Passar la public key del khost_sshedtorg al khost -->   ssh-keygen;  ramon@i22:ssh-copy-id -i ~/.ssh/mykey user03@khost
	(L'usuari user03 ha d'exsistir a khost_sshedtorg i alhora ha de ser un usuari kerberos dins de kserver)

	- Passar/exportar la clau desde servidor (kserver) fins a khost_sshedtorg (l'odre s'executa desde khost_sshedtorg) :  
		kadd -k /etc/krb5.keytab host/ssh.edt.org
	  (recordar que ha d'estar afegit "host/ssh.edt.org" com a principal abans en el servidor)



 
