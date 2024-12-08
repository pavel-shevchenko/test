FROM jenkins/agent:latest

USER root

# getent group docker
ARG DOCKERGID=999
# Setup users and groups
RUN addgroup --gid ${DOCKERGID} docker
RUN usermod -aG docker jenkins

# install docker cli
# RUN apt update && curl -fsSL https://get.docker.com | sh
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# ensures that /var/run/docker.sock exists
RUN touch /var/run/docker.sock

# changes the ownership of /var/run/docker.sock and gives jenkins user permissions to access /var/run/docker.sock
RUN getent group docker || groupadd docker && usermod -aG docker jenkins && chgrp docker /var/run/docker.sock && chown root:docker /var/run/docker.sock

USER jenkins
