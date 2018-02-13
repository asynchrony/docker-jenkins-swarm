# docker-jenkins-swarm
This container can be used to create and attach Jenkins slaves to a master node. Jenkins master must have the following in order to use this slave:
- The Swarm plugin must be installed
- TCP port for JNLP agents should be fixed to 50000
  - For ease of inital config, enable all protocol types (JNLP1-JNLP4)
  - Once communication is working, disable all protocols `except` JNLP4
- Authorization should be set to `matrix-based` mode, with the following set for anonymous users
  - Overall: READ
  - Agent: CONNECT, CREATE
  - Job: READ

The container must be started with the URL of the Jenkins master. There are also other optional settings that can be overridden.

Only SWARM_MASTER is required, all other settings have defaults.

CoreOS Example Config:
```
- name: jenkins-slave.service
    command: start
    content: |
    [Unit]
    Description=Jenkins Slave container
    After=docker.service
    Requires=docker.service

    [Service]
    Environment=DOCKER_IMAGE=asynchrony/docker-jenkins-swarm
    Environment=SWARM_EXECUTORS=*PREFFERED_NUMBER_EXCUTORS*
    Environment=SWARM_MASTER=*http://MY_JENKINS_HOST_NAME:8080*
    Environment=SWARM_LABELS=*SWARM_LABEL*
    Environment=SWARM_NAME=*SWARM_NAME*
    Environment=HOME=/home/jenkins
    Restart=always
    ExecStartPre=-/usr/bin/docker kill %p
    ExecStartPre=-/usr/bin/docker rm %p
    ExecStartPre=/usr/bin/docker pull $DOCKER_IMAGE
    ExecStart=/usr/bin/docker run --name %p -e SWARM_MASTER -e SWARM_EXECUTORS -e SWARM_LABELS -e SWARM_NAME -e HOME asynchrony/docker-jenkins-swarm
    ExecStop=/usr/bin/docker stop %p
```