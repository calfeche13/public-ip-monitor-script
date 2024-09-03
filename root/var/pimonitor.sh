MONITOR=$1
CURRENT_IP_UCI_OPTION=$2
SERVICE=$3
INTERVAL=$4
HANDLER_SCRIPT_PATH=$5
HISTORY_PATH=$6

echo "Starting PIMONITOR script"
while [ $MONITOR -eq 1 ]; do
    RETRIEVED_IP=$(curl -s "${SERVICE}")
    CURRENT_IP=$(uci get $CURRENT_IP_UCI_OPTION)
    if [ "$CURRENT_IP" != "${RETRIEVED_IP}" ]; then
        echo "IP changed from ${CURRENT_IP} to ${RETRIEVED_IP}"
        $HANDLER_SCRIPT_PATH $RETRIEVED_IP
        uci set ${CURRENT_IP_UCI_OPTION}=$RETRIEVED_IP
        uci commit
    fi
    sleep $INTERVAL
done