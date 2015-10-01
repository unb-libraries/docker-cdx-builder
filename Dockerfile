FROM unblibraries/jdk:oracle8
MAINTAINER Jacob Sanford <jsanford_at_unb.ca>

ENV OPENWAYBACK_VERSION 3.8.1
ENV OPENWAYBACK_LIB_VERSION 2.3.0
ENV WAYBACK_INSTALL_ROOT /opt
ENV WAYBACK_HOME ${WAYBACK_INSTALL_ROOT}/openwayback/openwayback
ENV MAVEN_VERSION 3.3.3
ENV JAVA_OPTS="-Djava.awt.headless=true -Xmx128M"
ENV WARC_DIR /warc-data
ENV WAYBACK_WARC_PATH /data/WARC/
ENV LC_ALL C

ENV MAVEN_ARCHIVE_FILENAME apache-maven-${MAVEN_VERSION}-bin.tar.gz
ENV MAVEN_DOWNLOAD_URL http://apache.mirror.iweb.ca/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_ARCHIVE_FILENAME}

# Install required packages.
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes
RUN apt-get update && \
  apt-get install -y git

# Download and set Maven in path.
WORKDIR ${WAYBACK_INSTALL_ROOT}
RUN wget ${MAVEN_DOWNLOAD_URL} && tar xvzpf ${MAVEN_ARCHIVE_FILENAME}
ENV PATH ${PATH}:${WAYBACK_INSTALL_ROOT}/apache-maven-${MAVEN_VERSION}/bin

# Clone, build OpenWayback with Maven and copy install JAR to Tomcat webapps dir.
RUN git clone https://github.com/iipc/openwayback.git openwayback
WORKDIR ${WAYBACK_INSTALL_ROOT}/openwayback
RUN mvn package && tar xvzpf ${WAYBACK_INSTALL_ROOT}/openwayback/dist/target/openwayback.tar.gz

CMD ["/sbin/my_init"]

# Copy phusion/baseimage inits.
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/my_init.d/*.sh

VOLUME [$WARC_DIR]
