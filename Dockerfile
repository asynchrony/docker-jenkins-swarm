FROM alpine:3.4

RUN apk --no-cache add openjdk7-jre curl

ENV SWARM_EXECUTORS 2
ENV SWARM_LABELS linux
ENV SWARM_NAME jenkins-linux
ENV SWARM_VERSION 2.2
ENV HOME /home/jenkins-slave

RUN adduser -h $HOME -D jenkins-slave \
 && curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-jar-with-dependencies.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$SWARM_VERSION/swarm-client-$SWARM_VERSION-jar-with-dependencies.jar \
 && chmod 755 /usr/share/jenkins

USER jenkins-slave

CMD ["sh", "-c", "java -jar /usr/share/jenkins/swarm-client-jar-with-dependencies.jar -master \"$SWARM_MASTER\" -executors $SWARM_EXECUTORS -labels \"$SWARM_LABELS\" -name \"$SWARM_NAME\" -fsroot \"$HOME\""]
