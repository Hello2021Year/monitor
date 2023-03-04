#!/bin/bash
source BSC_Node.conf


# check service exist or not
# shellcheck disable=SC1072
if [[ $(ps -ef | grep $PROCESS | wc -l) -lt $($PROCESS_NUM+1) ]]; then

   inform_info="The $SERVICE_NAME running abnormol"
   send_message LARK $SERVICE_NAME $inform_info $FATAL $UNRESOLVED
   for((i=1;i<=$MAX_TRIES;i++));
   do
       #/bin/bash /mnt/vdb1/FullNode/service.sh restart
       $RESTART_COMMAND
       if [[ $? -ne 0 ]];then
          inform_info="!!!"
          send_message LARK $SERVICE_NAME $inform_info $FATAL $UNRESOLVED
       fi
       sleep $(RESTART_INTERVAL)s
       if [[ $(ps -ef | grep $PROCESS | wc -l) -lt $($PROCESS_NUM+1) ]]; then
          inform_info="Restart the $SERVICE_NAME  failed $i times!!!"
          send_message LARK $SERVICE_NAME $inform_info $ERROR $UNRESOLVED
       else
          inform_info="Restart the $SERVICE_NAME  successfully!!!"
          send_message LARK $SERVICE_NAME $inform_info $INFO $RESOLVED
          break
       fi
   done
fi

