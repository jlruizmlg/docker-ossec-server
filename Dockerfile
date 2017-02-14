FROM phusion/baseimage:0.9.18
MAINTAINER Terence Kent <tkent@xetus.com>

#
# Follow the server installation parameters specified on the OSSEC website for
# ubuntu installations
#
RUN curl curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add - &&\
  echo "deb https://packages.wazuh.com/apt trusty main" >> /etc/apt/sources.list &&\
  apt-get update && apt-get -yf install expect realpath wazuh-manager


#
# Initialize the data volume configuration
#

ADD data_dirs.env /data_dirs.env
ADD init.bash /init.bash
# Sync calls are due to https://github.com/docker/docker/issues/9547
RUN chmod 755 /init.bash &&\
  sync && /init.bash &&\
  sync && rm /init.bash

#
# Add the bootstrap script
#
ADD run.bash /run.bash
RUN chmod 755 /run.bash

#
# Specify the data volume
#
VOLUME ["/var/ossec/data"]

# Expose ports for sharing
EXPOSE 1514/udp 1515/tcp

#
# Define default command.
#
ENTRYPOINT ["/run.bash"]
