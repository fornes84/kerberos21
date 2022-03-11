# kerberos21

Tenim **pràctica1+2** on hi tenim 1 docker en el nostre host un amb el kerberos server i un client ( en un altre host) MiniLinux Fedora 32 amb keberos client. El client s'instalarà tot a 'manija'.  

El servidor té un script per basicament crear els usuaris normals UNIX i alhora de kerberos (i 1 kerbero admin ?), executar els dimonis (krb5-admin-server i starkrb5-kdc).   

També farem que el client alhora tingui configurat PAM (concretament posnat dins /etc/pam.d/ els fitx --> common-auth  common-password  common-session)
perquè utilitzi el servidor de kerberos per autentificar (buscar a servidor el password que comença per 'k' al host kerberos) (això ho fa el modul pam_krb5) els usuaris locals que no tinguin PASSWORD i alhora es crearà un tiket validant que tenims drets com l'usuari conectat amb kerberos. 
 
389 --> LDAP (NO ESTA PQ EL SERVIDOR ESTA EN UN ALTRE DOCKER)
2200 --> SSH

 
Cal el EXPOSE del dockerfile --> si. 
  
**SERVIDOR:**    

sudo docker build -t balenabalena/kerberos21:kserver .  

sudo docker push balenabalena/kerberos21:kserver  

sudo docker run --rm --name kserver.edt.org -h kserver.edt.org -p 749:749 -p 88:88 -p 464:464 -it balenabalena/kerberos21:kserver  
(ull no cal --net 2hisix per AWS) 
 
sudo docker run --rm --name kserver.edt.org --net 2hisix -h kserver.edt.org -p 749:749 -p 88:88 -p 464:464 -it balenabalena/kerberos21:kserver  



**CLIENT(MINILINUX):**  
 (li hem afeigt client ssh configurat per propagar tiquets keberos)
  
 sudo docker build -t balenabalena/kerberos21:khost . 
 
 sudo docker push balenabalena/kerberos21:khost

 docker run --rm --name khost.edt.org -h khost.edt.org -it balenabalena/kerberos21:kshost  
 docker run --rm --name khost.edt.org -h khost.edt.org --net 2hisix -it balenabalena/kerberos21:kshost

    1  apt update
    2  apt install vim nmap procps -y
    3  nmap localhost
    4  apt install krb5-user
    5  cat /etc/krb5.conf
    6  kinit pere # ens logguejem com a pere
    7  klist   #mirem que veiem
    8  kadmin.local  #--> entrem a la linea de comandes kerberos-admin
    9  kadmin -p marta
    10 nmap kserver.edt.org


RECORDAR POSAR EN EL /ETC/HOST DEL HOST CLIENT ELS FQDN AMB LES IPS CORRESPONENTS D'AMAZON PQ S'APIGA RESOLDRE EL NOM kserver.edt.org!!!!!!**  


ARA PROVES AL HOST CLIENT (MINI LINIUX SENSE khost_sshedtorg) (CLIENT FINAL):

guest@i22: kinit pere    (ens logguejem com a pere (passwd kerveros) i es generarà un tiquet)

klist --> veiem ticket generat.

(ara, essent local01 un usuari local UNIX sense password)
su local01 --> I si demana el password kerberos "klocal01" i entra --> OK !!!

---------------------------------------------------------------------------------------------------------------------------------------------
**NOVA PRACTICA 3 CONTAINERS: khost (client ssh client kerveros) + khost_sshedtorg (servidor ssh, client kerv,pam) + kserver(serv kerb)**  
---------------------------------------------------------------------------------------------------------------------------------------------

Aquesta pràctica consiteix en que si creem un tiquet per a un usuari kerberos en un host client kerberos(khost), i fem un ssh cap  a un altre client kerberos amb servidor ssh, el ticket ha de valid per al ssh com autentificació i així no demanar-nos password (encara que en sshd_conf estigui habilitat).

RECORDAR que per autentificar-nos per ssh ho podem fer de 3 maneres, usuari-passd, clau publica-privada, i per kerberos (ticket). 

**CLIENT khost**

Igual que abans pero afegim el client ssh (configurat ssh_config pq propagui els tickets kerberos generats en conexions ssh a altres equips)


**CLIENT khost_sshedtorg**

 sudo docker build -t balenabalena/kerberos21:khost_sshedtorg . 
 
 sudo docker push balenabalena/kerberos21:khost_sshedtorg

 docker run --rm --name khost.edt.org -h khost.edt.org -p 2200:22 --net 2hisix -d balenabalena/kerberos21:kshost_sshedtorg

 docker exec -it khost.edt.org /bin/bash
 
CREEM UN ALTRE DOCKER CLIENT AMB KERBEROS ACCESSIBLE VIA SSH (TINDRA SERVIDOR SSH)
(el client final (khost) es connectarà via ssh amb aquest utilitzant un usuari kerberos, i el ssh no demanarà cap autentificació si s'ha fet tot bé, ja que el client khost propagarà el tiket cap a khost_sshedtorg)
      
Desde khost fariem:

   guest@i22: kinit user01 
   guest@i22: ssh user01@ssh.edt.org     (on user01 ha d'exisistir a khost_sshedtorg i alhora ha de ser un usuari kerveros)
	

També tindrà validació PAM (al fitx system-auth) per indica que ha de buscar a kserver els PASSWORD dels usuaris.

Servidor SSH : hem modificat el sshd_conf perquè acepti autentificació via kerberos.

HEM DE FER MANUALMENT (de moment el script no ho fa):

	- Modificació del /etc/hosts del khost i del khost_sshedtorg (mirar guia practica; 1er sempre el host "ssh.edt.org")
 
	- Passar la public key del khost_sshedtorg al khost -->   ssh-keygen;  ramon@i22:ssh-copy-id -i ~/.ssh/mykey user03@khost
	(L'usuari user03 ha d'exsistir a khost_sshedtorg i alhora ha de ser un usuari kerberos dins de kserver)

	- Alhora cal que el servidor (o més aviat el servei sshd) estigui kerberitzat per tal d'aceptar tiquet per tal d'autentificar, per tant importem la clau.
      
      EX:    kadmin -p admin -kadmin -q "ktadd -k /etc/krb5.keytab  host/ssh.edt.org"
	    (recordar que ha d'estar afegit "host/ssh.edt.org" com a principal abans en el servidor) (aquí sota ho veiem)

**SERVIDOR kserver:**

Afegim al script la següent ordre:
kadmin.local -q "addprinc -randkey host/ssh.edt.org"    #SERVEIX PER PERMETRE A UN HOST AMB UN SERVEI XXX (p.e ssh) KERBERITZARSE (QUE PUGUI UTILTIZAR KERBEROS) si aquest disposa de la clau





 
