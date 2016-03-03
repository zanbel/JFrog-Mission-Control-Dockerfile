# Pull base ubuntu trusty image
FROM java:8
MAINTAINER royz

# intall utils
RUN apt-get update && apt-get install -y curl unzip

RUN useradd mc

# download mc
# need to provide a URL do download
# currently using local artifactory instance to get latest release version
RUN curl -L "http://192.168.0.1:8080/artifactory/mc/org/jfrog/jfrog-mission-control/\[RELEASE\]/jfrog-mission-control-\[RELEASE\].zip" -o /tmp/jfrog-mission-control.zip && \
        mkdir -p /mc /etc/opt/jfrog /var/opt/jfrog/mission-control &&\
        unzip /tmp/jfrog-mission-control.zip -d /mc/ && \
        ln -s /mc/mission-control-1.0/logs /var/opt/jfrog/mission-control &&\
        ln -s /mc/mission-control-1.0/etc /etc/opt/jfrog/mission-control &&\
        ln -s /mc/mission-control-1.0/data /var/opt/jfrog/mission-control &&\
        chown -R mc: /mc /etc/opt/jfrog/mission-control /var/opt/jfrog/mission-control &&\
        rm /tmp/jfrog-mission-control.zip &&\
        apt-get clean all

VOLUME ["/etc/opt/jfrog/mission-control", "/var/opt/jfrog/mission-control/data" ,"/var/opt/jfrog/mission-control/logs"]

EXPOSE 8080

USER mc

ENTRYPOINT  ["/mc/mission-control-1.0-Preview/bin/mission-control.sh"]
