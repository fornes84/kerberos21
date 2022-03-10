# kerberos server
FROM debian:latest
LABEL version="1.0"
LABEL author="@edt ASIX-M06"
LABEL subject="Kerberos server"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install krb5-admin-server mlocate tree nmap less vim man procps finger passwd libpam-pwquality libpam-mount libpam-krb5
# PART LDAP:
RUN libpam-ldapd libnss-ldapd nslcd nslcd-utils ldap-utils sshfs openssh-server samba-client cifs-utils
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
