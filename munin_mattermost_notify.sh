#!/bin/bash
# Script to post Munin alerts to a Mattermost server.
#
# Please change the variables according to your setup.
#
# Don't know Mattermost - The open source Slack alternative?
# Take a look at https://mattermost.com :-)
#
# Copyright (c) 2017 Bjoern Roland <dev@bjoernr.de>

#### munin configuration
# contact.mattermost.command | /etc/munin/munin_mattermost_notify.sh "${var:group}" "${var:host}" "${var:graph_category}" "${var:graph_title}" "${var:worst}"
# contact.mattermost.text ${if:cfields \u000A* **CRITICALs**${loop< >:cfields \u000A  * ${var:label} is ${var:value} ${if:extinfo : ${var:extinfo}}}}${if:wfields \u000A* **WARNINGs**${loop< >:wfields \u000A  * ${var:label} is ${var:value} ${if:extinfo : ${var:extinfo}}}}${if:ufields \u000A* **UNKNOWNs**${loop< >:ufields \u000A  * ${var:label} is ${var:value} ${if:extinfo : ${var:extinfo}}}}${if:fofields \u000A* **OKs**${loop< >:fofields \u000A  * ${var:label} is ${var:value} ${if:extinfo : ${var:extinfo}}}}
# contacts mattermost


#### variables
MM_CHANNEL="munin-alerts" # Mattermost channel name
MM_USERNAME="Munin Alert" # Mattermost username for the bot
MM_ICON="https://myserverfarm.de/mattermost-munin-icon.png" # Mattermost icon for the bot
MM_WEBHOOK_URL="https://chat.myserverfarm.de/hooks/xyz" # Mattermost incoming webhook URL; https://docs.mattermost.com/developer/webhooks-incoming.html
MUNIN_URL="https://mon.myserverfarm.de/munin/" # Munin root URL

#############################################
#############################################
##    Do not change anything afterwards    ##
##    unless you know what you're doing    ##
#############################################
#############################################

# munin values
group=$1
host=$2
graph_category=$3
graph_title=$4
level=$5
# munin text will be piped to the script
munin_text=`cat`

# make level output a little prettier in Mattermost
if [ "$level" == "ok" ]; then
    mm_level=":white_check_mark: OK"
elif [ "$level" == "warning" ]; then
    mm_level=":warning: WARNING"
elif [ "$level" == "critical" ]; then
    mm_level=":exclamation: CRITICAL"
else
    mm_level=":grey_question: UNKNOWN"
fi

read -r -d '' INPUTTEXT <<- EOM
##### ${host} - ${graph_category} ${graph_title}
| Category              | Value             |
|-----------------------|-------------------|
| Group                 | ${group}          |
| Host                  | ${host}           |
| Munin graph category  | ${graph_category} |
| Level                 | ${mm_level}       |
| Alert name            | ${graph_title}    |

${munin_text}

${MUNIN_URL}
${MUNIN_URL}${group}/${host}/#${graph_category}
EOM

PAYLOAD="{\"channel\":\"${MM_CHANNEL}\", \"username\":\"${MM_USERNAME}\", \"icon_url\":\"${MM_ICON}\", \"text\":\"${INPUTTEXT}\"}"

$(which curl) -s -o /dev/null -X POST -d "payload=${PAYLOAD}" $MM_WEBHOOK_URL
