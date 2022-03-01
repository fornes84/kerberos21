# kerberos21

tenim **practica1** on hi tenim 2 dockers un amb el kerberos server i l'altre amb keberos client. Els dos tenen Dockerfile per a copiar arxius de configuració.
Només el servidor té un script per basicament crear els usuaris normals i de kerberos (i kerbero admin), executar els dimonis (2). El servidor alhora ha de tenir configurat l'arxiu 
PAM perquè utilitzi kerberos per autentificar els usuaris. 
Aquí no caldrà EXPORTAR ports ja que tot treballa amb la amteixa xarxa docker 2hisix.

