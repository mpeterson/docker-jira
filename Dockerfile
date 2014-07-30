FROM mpeterson/base:0.1
MAINTAINER mpeterson <docker@peterson.com.ar>

# Make APT non-interactive
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Change this ENV variable to skip the docker cache from this line on
ENV LATEST_CACHE 2014-07-29T19:00-03:00

# Upgrade the system to the latest version
RUN apt-get update
RUN apt-get upgrade -y

# We want the latest stable version of java
RUN sudo apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update

RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y --force-yes oracle-java7-installer curl xmlstarlet

# Install packages needed for this image
RUN curl -Lks -o /root/jira.tar.gz http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.3.1.tar.gz
RUN /usr/sbin/useradd --create-home --home-dir /opt/jira --shell /bin/bash jira
RUN tar zxf /root/jira.tar.gz --strip=1 -C /opt/jira
RUN rm /root/jira.tar.gz

# This after the package installation so we can use the docker cache
RUN mkdir /build
ADD . /build

# Starting the installation of this particular image

# Modify the location of data
VOLUME ["/data"]
ENV DATA_DIR /data

RUN ln -s $DATA_DIR /opt/jira-home
RUN echo "jira.home = /opt/jira-home" > /opt/jira/atlassian-jira/WEB-INF/classes/jira-application.properties
RUN chown -R jira:jira /opt/jira
RUN chown -R jira:jira /opt/jira-home

RUN mv /opt/jira/conf/server.xml /opt/jira/conf/server-backup.xml

RUN cp -a /opt/jira /opt/.jira.orig

ENV CONTEXT_PATH ROOT

EXPOSE 8080

# End of particularities of this image

# Give the possibility to override any file on the system
RUN cp -R /build/overrides/. / || :

# Add run script
RUN cp -R /build/run_jira.sh /sbin/run_jira.sh
RUN chown root:root /sbin/run_jira.sh

# Clean everything up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /build

CMD ["/sbin/run_jira.sh"]
