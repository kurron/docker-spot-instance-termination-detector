FROM ubuntu:16.04

MAINTAINER Ron Kurr "kurr@jvmguy.com"

# Create non-root user
RUN groupadd --system microservice --gid 444 && \
useradd --uid 444 --system --gid microservice --home-dir /home/microservice --create-home --shell /sbin/nologin --comment "Docker image user" microservice && \
chown -R microservice:microservice /home/microservice

# default to being in the user's home directory
WORKDIR /home/microservice

ENTRYPOINT ["/home/microservice/entrypoint.sh"]

COPY entrypoint.sh /home/microservice/entrypoint.sh

RUN apt-get -qq update && \
    apt-get -qqy install curl && \
    apt-get clean

# Switch to the non-root user
USER microservice
