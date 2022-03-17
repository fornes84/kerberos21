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
 
sudo docker run --rm --name kserver.edt.org --net 2hisix -h kserver.edt.org -p 749:749 -p 88:88 -p 464:464 --net 2hisix -d balenabalena/kerberos21:kserver  


**CLIENT(MINILINUX):**  

 (li hem afeigt client ssh configurat per propagar tiquets keberos)
  
 sudo docker build -t balenabalena/kerberos21:khost . 
 
 sudo docker push balenabalena/kerberos21:khost

 docker run --rm --name khost.edt.org -h khost.edt.org -it balenabalena/kerberos21:khost21  

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

 docker run --rm --name ssh.edt.org -h ssh.edt.org -p 2200:22 --net 2hisix -d balenabalena/kerberos21:khost_sshedtorg

 docker exec -it ssh.edt.org /bin/bash
 
CREEM UN ALTRE DOCKER CLIENT AMB KERBEROS ACCESSIBLE VIA SSH (TINDRA SERVIDOR SSH)
(el client final (khost) es connectarà via ssh amb aquest utilitzant un usuari kerberos, i el ssh no demanarà cap autentificació si s'ha fet tot bé, ja que el client khost propagarà el tiket cap a khost_sshedtorg)
      
Desde khost fariem:

   guest@i22: kinit user02 
   guest@i22: ssh user02@ssh.edt.org     (on user02 ha d'exisistir a khost_sshedtorg i alhora ha de ser un usuari kerveros)
	

També tindrà validació PAM (al fitx system-auth) per indica que ha de buscar a kserver els PASSWORD dels usuaris.

Servidor SSH : hem modificat el sshd_conf perquè acepti autentificació via kerberos.

**HEM DE FER MANUALMENT (de moment el script no ho fa):**

	- Modificació del /etc/hosts del khost i del khost_sshedtorg (mirar guia practica; 1er sempre el host "ssh.edt.org")
 
	(recordar els usuari user01,user02,user03 han d'exsistir a khost_sshedtorg i alhora ha de ser usuaris kerberos dins de kserver)

	- Alhora cal que el servidor SSH (o més aviat el servei sshd) estigui kerberitzat per tal d'aceptar tiquet per tal d'autentificar, per tant importem la clau.
      
      kadmin -p user01/admin -w kuser01 -q "ktadd -k /etc/krb5.keytab  host/ssh.edt.org"
      
------------SI LO D'ADALT NO VA (NO PROPAGA EL TICKET VIA SSH)------------------

root@ssh:/opt/docker# kadmin
Authenticating as principal user01/admin@EDT.ORG with password.
Password for user01/admin@EDT.ORG: 
kadmin:  ktadd -k /etc/krb5.keytab  host/ssh.edt.org
Entry for principal host/ssh.edt.org with kvno 5, encryption type aes256-cts-hmac-sha1-96 added to keytab WRFILE:/etc/krb5.keytab.

kadmin: ktadd -k /etc/krb5.keytab  host/ssh.edt.org

---------------------------------------------------------------------

	    (recordar que ha d'estar afegit "host/ssh.edt.org" com a principal abans en el servidor) (aquí sota ho veiem)

**SERVIDOR kserver:**

PROVEM:
kadmin.local -q "listprincs" --> llistem usuaris kerveros

kadmin -p user01/admin --> entrar com a admin
kadmin -p user02/admin --> entrar com a usuari

al script hem de tenir la següent ordre:

kadmin.local -q "addprinc -randkey host/ssh.edt.org"   
 #SERVEIX PER CREAR UNA CLAU QUE SI UN HOST L'IMPORTA EL SERVEI XXX (p.e ssh) PODRA  KERBERITZARSE (QUE PUGUI UTILTIZAR KERBEROS)

----------------------------------------------------------------------
**PROVES: AL ssh.edt.org**

vim /etc/hosts

Posar la IP local de container de kserver.edt.org i el seu propi:

172.18.0.2 ssh.edt.org
172.18.0.3  kserver.edt.org

Si el principal de host que s'ha creat al servidor kerberos és host/sshd.edt.org es podrà realitzar l'accés kerberitzat només si es connecta al servidor usant aquest hosname. És a dir, amb les ordres:

ssh user02@ssh.edt.org  (OK) 
ssh user02@localhost     (NO!) --> PERO ENS VA BE PER VEURE SI SSH VA BE !

ALTRE PROVA:

l'usuari local01 sol·licita un ticket de user01 amb l'ordre kinit user01.
Un cop obtingui ticket l'usuari local01 realitza l'ordre ssh user01@sshd.edt.org i no li ha demanar passwd.
i
si fem:

[user02@sshd ~]$ klist 
Ticket cache: FILE:/tmp/krb5cc_1003_h55yoBfeGG
Default principal: user02@EDT.ORG
Valid starting     Expires            Service principal
02/22/19 16:49:35  02/23/19 16:49:35  krbtgt/EDT.ORG@EDT.ORG
02/22/19 16:49:56  02/23/19 16:49:35  host/sshd.edt.org@EDT.ORG

**kdestroy (molt importat destruir ticket després de cada prova)**

 a més a més del seu ticket té el ticket del servidor sshd, que li permet iniciar sessió ssh de manera desatesa.


**PROVES EN EL khost:**

/etc/hosts:

172.19.0.1 ssh.edt.org kserver.edt.org
(la IP es la del host, no es cap docker)

kinit user02

kdestroy



+

Idem que adalt.


-------- ------------------------ - - -- - -- - - - - -- - - - - -- - - -

A RECORDAR:

nmap localhost  == nmap i22 --> Veiem els ports dels nostres serveis que es comuniquen entre si

nmap nostreIPpublica --> Veiem els ports dels nostres serveis i els ports que publiquem (inclosos els ports dels docker)

DINS DEL DOCKERFILE EXPOSE 22--> El docker compartira/donara visibilitat al port del servei en el host on es desplegat
QUAN FEM docker run -p 2200:22 el que estem fent es agafar el port del servei del docker (ex ssh) fem que les peticions del host s'escoltin per el 2200.
 -- - - - - - -- 


 
