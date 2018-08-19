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
RUN mkdir -p /var/log/cantaloupe
RUN mkdir -p /var/cache/cantaloupe
RUN chown -R cantaloupe /var/log/cantaloupe
RUN chown -R cantaloupe /var/cache/cantaloupe 
RUN chown cantaloupe /etc/cantaloupe.properties

USER cantaloupe
CMD ["sh", "-c", "java -Dcantaloupe.config=/etc/cantaloupe.properties -Daws.accessKeyId=$AWS_ACCESS_KEY_ID -Daws.secretKey=$AWS_SECRET_ACCESS_KEY -Xmx2g -jar /usr/local/cantaloupe/Cantaloupe-$CANTALOUPE_VERSION.war"]
