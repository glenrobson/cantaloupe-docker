FROM mostalive/ubuntu-14.04-oracle-jdk8

# Adapted from:
# https://github.com/kaij/cantaloupe
# https://github.com/MITLibraries/docker-cantaloupe

ENV CANTALOUPE_VERSION 3.4.1
EXPOSE 8182

# Update packages and install tools
RUN apt-get update -y && apt-get install -y wget unzip graphicsmagick curl build-essential cmake

#Build OpenJPEG
RUN wget -c https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz -O openjpeg-2.3.0.tar.gz \
     && tar -zxvf openjpeg-2.3.0.tar.gz \
     && cd openjpeg-2.3.0 \
     && mkdir -v build \
     && cd build \
     && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. \
     && make \
     && make install

# run non priviledged
RUN adduser --system cantaloupe

#
# Cantaloupe
#
WORKDIR /tmp
RUN curl -OL https://github.com/medusa-project/cantaloupe/releases/download/v$CANTALOUPE_VERSION/Cantaloupe-$CANTALOUPE_VERSION.zip \
 && mkdir -p /usr/local/ \
 && cd /usr/local \
 && unzip /tmp/Cantaloupe-$CANTALOUPE_VERSION.zip \
 && ln -s Cantaloupe-$CANTALOUPE_VERSION cantaloupe \
 && rm -rf /tmp/Cantaloupe-$CANTALOUPE_VERSION \
 && rm /tmp/Cantaloupe-$CANTALOUPE_VERSION.zip

COPY cantaloupe.properties /etc/cantaloupe.properties
RUN mkdir -p /var/log/cantaloupe \
 && mkdir -p /var/cache/cantaloupe \
 && chown -R cantaloupe /var/log/cantaloupe \
 && chown -R cantaloupe /var/cache/cantaloupe \
 && chown cantaloupe /etc/cantaloupe.properties

RUN mkdir -p /usr/local/jmx_monitor
COPY lib/jmx-monitor-1.0.jar /usr/local/jmx_monitor
COPY lib/checkMemory.sh /usr/local/jmx_monitor
RUN chmod 755 /usr/local/jmx_monitor/checkMemory.sh
RUN mkdir /var/log/jmx && chown cantaloupe /var/log/jmx
RUN echo "* * * * * /usr/local/jmx_monitor/checkMemory.sh >> /var/log/jmx/memory.log" > /tmp/cantaloupe_crontab
RUN crontab -u cantaloupe /tmp/cantaloupe_crontab

COPY startup.sh /usr/local/
RUN export CANTALOUPE_VERSION=$CANTALOUPE_VERSION
RUN chmod 755 /usr/local/startup.sh

RUN echo 'cantaloupe ALL=(ALL) NOPASSWD: /usr/sbin/cron' >> /etc/sudoers

USER cantaloupe
CMD ["sh", "-c", "/usr/local/startup.sh"]
