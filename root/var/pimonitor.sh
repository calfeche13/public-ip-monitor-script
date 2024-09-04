SCRIPT_FOR=$1
CURRENT_IP_UCI_OPTION=$2
SERVICE=$3
INTERVAL=$4
HANDLER_SCRIPT_PATH=$5
HISTORY_PATH=$6

echo "Starting PIMONITOR for ${SCRIPT_FOR} script"
while [ 1 ]; do
    RETRIEVED_IP=$(curl -s "${SERVICE}")
    CURRENT_IP=$(uci -q get "${CURRENT_IP_UCI_OPTION}")
    if [ "$CURRENT_IP" != "${RETRIEVED_IP}" ]; then
        echo "IP changed from ${CURRENT_IP} to ${RETRIEVED_IP}"
        sh $HANDLER_SCRIPT_PATH $RETRIEVED_IP
        uci set ${CURRENT_IP_UCI_OPTION}=$RETRIEVED_IP
        uci commit
        {
            flock -s 200

            if [ ! -s "${HISTORY_PATH}" ] || [ ! $(cat "${HISTORY_PATH}" 2>/dev/null | jq type 2>/dev/null) ]; then
                echo "{}" > "${HISTORY_PATH}"
            fi

            IP_CHANGE_INFO="{ \"change_timestamp\": \"$(date '+%Y-%m-%d %H:%M:%S')\", \"from\": \"${CURRENT_IP}\", \"to\": \"${RETRIEVED_IP}\" }"
            echo $(jq --argjson hist_info "${IP_CHANGE_INFO}" ".history_${SCRIPT_FOR} += [\$hist_info]" "${HISTORY_PATH}") > "${HISTORY_PATH}"

        } 200>".history_flock"
    fi
    sleep $INTERVAL
done