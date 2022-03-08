**SERVIDOR PER A AWS KEBEROS AMB PAM:**  
docker run --rm --name kserverpl.edt.org -h kserverpl.edt.org -p 88:88 -p 464:464 -p 749:749 -p --net 2hisix -it balenabalena/kerberos21:khost_pam21

**SERVIDOR PER A AWS DE LDAP:**  
docker run --rm --name ldap.edt.org -h ldap.edt.org -p 389:389 --net 2hisix -d balenabalena/ldap21:groups  

https://github.com/edtasixm11/k19/tree/master/k19:khostpl
