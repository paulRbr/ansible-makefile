FROM trainlineeurope/docker-ansible:alpine3

RUN  apk add --update make bash git

WORKDIR /opt/ansible
COPY Makefile .
#COPY pass.sh  .
