#!/bin/bash

POLL_INTERVAL=${POLL_INTERVAL:-5}
NOTICE_URL=${NOTICE_URL:-http://169.254.169.254/latest/meta-data/spot/termination-time}

INSTANCE_ID=$(curl --silent --location http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl --silent --location http://169.254.169.254/latest/dynamic/instance-identity/document// | jq --raw-output '.region')

echo $(date): $(/usr/local/bin/aws --version)
echo $(date): $(/usr/local/bin/jq --version)
echo "Polling ${NOTICE_URL} every ${POLL_INTERVAL} second(s)"
echo "Will generate notification event for instance ${INSTANCE_ID} in ${REGION} once a termination notice is detected."

while http_status=$(curl --output /dev/null --write-out '%{http_code}' --silent --location ${NOTICE_URL}); [ ${http_status} -ne 200 ]; do
  echo $(date): ${http_status}
  sleep ${POLL_INTERVAL}
done

echo $(date): ${http_status}
echo Termination Notice Detected!

TIME=$(date -u)

JSON=$(cat <<END_HEREDOC
[
    {
        "Time": "${TIME}",
        "Source": "spot.instance.watcher",
        "Resources": ["${INSTANCE_ID}"],
        "DetailType": "spotInstanceWatcherDetailType",
        "Detail": "{}"
    }
]
END_HEREDOC
)

echo Sending off termination event to Cloud Watch Events
echo "${JSON}"
aws --region "${REGION}" events put-events --entries "${JSON}"

