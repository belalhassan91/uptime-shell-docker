#!/bin/bash
services_url=( $(cat services.json | jq -r '.[].url') )
services_port=( $(cat services.json | jq -r '.[].port') )

send_slack() {

        if [ -z "${1}" ];then
                echo "No text to send ? Are you kidding me ?"
                exit 1
        fi
        [ -z "${SLACK_CHAN}" ] && SLACK_CHAN="#test"
        [ -z "${SLACK_USERNAME}" ] && SLACK_USERNAME=uptime
        #[ -z "${SLACK_ICON}" ] && SLACK_ICON=":postal_horn:"

        #URL=

        curl -X POST --data-urlencode 'payload={"channel": "'${SLACK_CHAN}'", "username": "'${SLACK_USERNAME}'", "attachments": [{"color": "#FF0000","blocks": [{"type": "section","text": {"type": "plain_text","text": "'"${*}"'","emoji": true    }}]}]}' ${URL} > /dev/null 2>&1
}

URL=( $(cat slack.json | jq -r '.webhook_url') )
SLACK_CHAN=( $(cat slack.json | jq -r '.channel') )

#echo $URL
#echo $SLACK_CHAN

i=0
for service in "${services_url[@]}"
do
        port=${services_port[$i]}
        url="http://$service:$port"
        status=$( curl  -s -o /dev/null -w "%{http_code}" ${url} )
        if [[ $status != 200 ]]
        then
                send_slack '['$env']': $service is down.
        fi

        i=$((i+1))
done

