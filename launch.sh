#!/bin/bash

# Example of how to luanch the container on a spot instance
docker run \
       --rm \
       --env POLL_INTERVAL=5 \
       --env NOTICE_URL=http://169.254.169.254/latest/meta-data/spot/termination-time \
       --interactive \
       --name spot-watch \
       --tty \
       kurron/spot-instance-termination-detector:latest
