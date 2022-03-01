# kerberos client
FROM debian:latest
LABEL version="1.0"
LABEL author="@edt ASIX-M06"
LABEL subject="Kerberos client"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install krb5-user vim tree nmap less man procps 
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
