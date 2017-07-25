FROM centos:6.8

ARG JENKINS_VERSION=2.19.1
ARG OPEN_JDK_VERSION=1.8.0

RUN yum install -y java-${OPEN_JDK_VERSION}-openjdk \
                   git \
                   curl 

RUN mkdir /opt/jenkins && \
    curl -fL http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war \
         -o /opt/jenkins/jenkins.war

RUN mkdir /opt/awscli && \
    curl https://s3.amazonaws.com/aws-cli/awscli-bundle.zip \
         -o /usr/share/awscli-bundle.zip && \
    unzip /opt/awscli/awscli-bundle.zip -d /opt/awscli/ && \
    /opt/awscli/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

COPY ./init.groovy.d  /var/jenkins_home/init.groovy.d

RUN mkdir /backup && chmod +r /backup

EXPOSE 8080
VOLUME /var/jenkins_home

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
