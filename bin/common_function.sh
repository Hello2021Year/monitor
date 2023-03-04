source BSC_Node.conf
CUR_PATH=/mnt/monitor/bin

function send_message(){
  message_type=$1
  service_name=$2
  message=$3
  warning_level=$4
  status=$5

  # shellcheck disable=SC1073
  if [[ $message_type == "LARK" ]];then
     $PYTHON $CUR_PATH/send_lark_message.py $LARK_WEBHOOK $message $warning_level $status
  elif [[ $message_type == "TG" ]];then
     $PYTHON $CUR_PATH/send_tg_message.py $BOT_TOKEN $CHAT_ID $SERVICE_NAME $message $warning_level $status
  else
    $PYTHON $CUR_PATH/send_tg_message.py $BOT_TOKEN $CHAT_ID $SERVICE_NAME $message $warning_level $status
    $PYTHON $CUR_PATH/send_lark_message.py $LARK_WEBHOOK $message $warning_level $status
  fi
}