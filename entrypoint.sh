#!/bin/bash

POLL_INTERVAL=${POLL_INTERVAL:-5}
NOTICE_URL=${NOTICE_URL:-http://169.254.169.254/latest/meta-data/spot/termination-time}

INSTANCE_ID=$(curl --location http://169.254.169.254/latest/meta-data/instance-id)

echo $(date): $(/usr/local/bin/aws --version)
echo "Polling ${NOTICE_URL} every ${POLL_INTERVAL} second(s)"
echo "Will generate notification event for instance ${INSTNACE_ID} once a termination event is detected."

while http_status=$(curl --output /dev/null --write-out '%{http_code}' --silent --location ${NOTICE_URL}); [ ${http_status} -ne 200 ]; do
  echo $(date): ${http_status}
  sleep ${POLL_INTERVAL}
done

echo $(date): ${http_status}
echo Termination Notice Detected!
