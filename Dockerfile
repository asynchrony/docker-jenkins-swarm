FROM openjdk:8-jre

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      gnupg2 \
 && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
 && echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      docker-engine=1.11.2-0~jessie \
      git \
      openssh-client \
      python-pip \
      xvfb \
      libxss1 \
      gconf2 \
 && rm -rf /var/lib/apt/lists/* \
 && pip install awscli

ENV SWARM_EXECUTORS 2
ENV SWARM_LABELS linux
ENV SWARM_NAME jenkins-linux
ENV SWARM_VERSION 2.2
ENV HOME /home/jenkins-slave

RUN mkdir -p $HOME \
 && curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$SWARM_VERSION/swarm-client-$SWARM_VERSION-jar-with-dependencies.jar

CMD ["sh", "-c", "java -jar /usr/share/jenkins/swarm-client-jar-with-dependencies.jar -master \"$SWARM_MASTER\" -executors $SWARM_EXECUTORS -labels \"$SWARM_LABELS\" -name \"$SWARM_NAME\" -fsroot \"$HOME\""]
