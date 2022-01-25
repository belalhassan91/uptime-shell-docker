#!/bin/bash
services_url=( $(cat services.json | jq -r '.[].url') )
services_port=( $(cat services.json | jq -r '.[].port') )
services_path=( $(cat services.json | jq -r '.[].path') )

send_slack() {

        if [ -z "${1}" ];then
                echo "No text to send ? Are you kidding me ?"
                exit 1
        fi
        [ -z "${SLACK_CHAN}" ] && SLACK_CHAN="#test"
        [ -z "${SLACK_USERNAME}" ] && SLACK_USERNAME=uptime
        #[ -z "${SLACK_ICON}" ] && SLACK_ICON=":postal_horn:"

        #URL=

        curl -X POST --data-urlencode 'payload={"channel": "'${SLACK_CHAN}'", "username": "'${SLACK_USERNAME}'", "attachments": [{"color": "'${SLACK_COLOR}'","blocks": [{"type": "section","text": {"type": "plain_text","text": "'"${*}"'","emoji": true    }}]}]}' ${URL} > /dev/null 2>&1
}

URL=( $(cat slack.json | jq -r '.webhook_url') )
SLACK_CHAN=( $(cat slack.json | jq -r '.channel') )

#echo $URL
#echo $SLACK_CHAN

i=0
status_last=1
for service in "${services_url[@]}"
do
        port=${services_port[$i]}
        path=${services_path[$i]}
        url="http://$service:$port$path"
        status=$( curl  -s -o /dev/null -w "%{http_code}" ${url} )
        if [[ $status != 200 ]]
        then
                SLACK_COLOR=#FF0000
                send_slack '['$env']': $service is down.
                echo 0 > /$service.txt
        fi

        if [ -f "/$service.txt" ]
        then
                status_last=$(cat /$service.txt )
        fi

        if [[ $status == 200 ]] && [[ $status_last == 0 ]]
        then
                SLACK_COLOR=#00FF00
                send_slack '['$env']': $service is up.
                echo 1 > /$service.txt
        fi
        i=$((i+1))
done
