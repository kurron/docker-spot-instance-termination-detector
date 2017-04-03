#!/bin/bash

# docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker tag dockerspotinstanceterminationdetector_spot-termination-poller:latest kurron/spot-instance-termination-detector:latest
docker images

# Usage:  docker push [OPTIONS] NAME[:TAG]
docker push kurron/spot-instance-termination-detector:latest
