#!/bin/bash
source ../conf/Test_Monitor.conf
source ./common_function.sh

# check service exist or not
# shellcheck disable=SC1072
if [[ $(ps -ef | grep $PROCESS_NAME | wc -l) -lt $PROCESS_NUM+1 ]]; then
   HOST=`hostname`
   IP=`hostname -i`
   HOST_IP="$HOST:$IP"
   SERVICE_NAME="($HOST_IP) $SERVICE_NAME"
   inform_info="服务$SERVICE_NAME运行异常!"
   send_message $SEND_MESSAGE_TYPE "$SERVICE_NAME" "$inform_info" $FATAL $UNRESOLVED
   for((i=1;i<=$MAX_TRIES;i++));
   do
       $RESTART_COMMAND
       if [[ $? -ne 0 ]];then
          inform_info="重启命令$(RESTART_COMMAND)运行失败!"
          send_message $SEND_MESSAGE_TYPE "$SERVICE_NAME" "$inform_info" $ERROR $EXECFAILED
       fi
       sleep $RESTART_INTERVAL
       if [[ $(ps -ef | grep $PROCESS_NAME | wc -l) -lt $PROCESS_NUM ]]; then
          inform_info="重启 $SERVICE_NAME 失败$i次!!"
          send_message $SEND_MESSAGE_TYPE "$SERVICE_NAME" "$inform_info" $ERROR $UNRESOLVED
       else
          inform_info="重启 $SERVICE_NAME 成功!"
          send_message $SEND_MESSAGE_TYPE "$SERVICE_NAME" "$inform_info" $INFO $RESOLVED
          break
       fi
   done
fi
