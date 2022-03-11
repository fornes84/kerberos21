# kerberos server
FROM debian:latest
LABEL version="1.0"
LABEL author="@edt ASIX-M11"
LABEL subject="Kerberos client amb ssh"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install krb5-user mlocate tree nmap less vim man procps finger passwd libpam-pwquality libpam-krb5 openssh-client openssh-server sshfs
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
EXPOSE 2200 22
