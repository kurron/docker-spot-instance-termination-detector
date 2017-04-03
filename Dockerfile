FROM python:latest

MAINTAINER Ron Kurr "kurr@jvmguy.com"

# Create non-root user
RUN groupadd --system microservice --gid 444 && \
useradd --uid 444 --system --gid microservice --home-dir /home/microservice --create-home --shell /sbin/nologin --comment "Docker image user" microservice && \
chown -R microservice:microservice /home/microservice

# default to being in the user's home directory
WORKDIR /home/microservice

ENTRYPOINT ["/home/microservice/entrypoint.sh"]

# Set the AWS environment variables
ENV AWS_ACCESS_KEY_ID OVERRIDE ME
ENV AWS_SECRET_ACCESS_KEY OVERRIDE_ME
ENV AWS_REGION us-west-2

COPY entrypoint.sh /home/microservice/entrypoint.sh

RUN pip install --upgrade python-dateutil awscli

RUN apt-get -qq update && \
    apt-get -qqy install curl && \
    apt-get clean


# Switch to the non-root user
USER microservice
