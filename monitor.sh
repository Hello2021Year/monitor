#!/bin/bash
source ../conf/monitor.conf
CUR_PATH=/mnt/monitor/bin

# check service exist or not
if [[ $(ps -ef | grep "/erigon-2.37.0/build/bin/erigon" | wc -l) -lt 2 ]]; then

   inform_info="The erigon is not running!!!"
   $PYTHON $CUR_PATH/send_tg_message.py $BOT_TOKEN $CHAT_ID $FULLNODE_SERVICE "$inform_info" $FATAL
   $PYTHON $CUR_PATH/send_lark_message.py $LARK_WEBHOOK $FULLNODE_SERVICE "$inform_info" $FATAL
   # restart the service and check the service again
   for((i=1;i<=$MAX_TRIES;i++));
   do
       inform_info="Trying to restart FullNode service $i times"
       $PYTHON $CUR_PATH/send_tg_message.py $BOT_TOKEN $CHAT_ID $ERIGON_SERVICE "$inform_info" $INFO
       $PYTHON $CUR_PATH/send_lark_message.py $LARK_WEBHOOK $ERIGON_SERVICE "$inform_info" $INFO
       #/bin/bash /mnt/vdb1/FullNode/service.sh restart
       if [[ $? -ne 0 ]];then
          inform_info="Restart the ERIGON service failed!!!"
          $PYTHON $CUR_PATH/send_tg_messagae.py $BOT_TOKEN $CHAT_ID $ERIGON_SERVICE "$inform_info" $ERROR
          $PYTHON $CUR_PATH/send_lark_message.py $LARK_WEBHOOK $ERIGON_SERVICE "$inform_info" $ERROR
       fi
       sleep 60s
       if [[ $(ps -ef | grep "/erigon-2.37.0/build/bin/erigon" | wc -l) -lt 2 ]]; then
          inform_info="Restart the FullNode Service failed $i times!!!"
          $PYTHON $CUR_PATH/send_tg_message.py $BOT_TOKEN $CHAT_ID $ERIGON_SERVICE "$inform_info" $ERROR
          $PYTHON $CUR_PATH/send_lark_message.py $LARK_WEBHOOK $ERIGON_SERVICE "$inform_info" $ERROR
       else
          inform_info="Restart the ERIGON successfully!!!"
          $PYTHON $CUR_PATH/send_tg_message.py $BOT_TOKEN $CHAT_ID $ERIGON_SERVICE "$inform_info" $RESOLVED
          $PYTHON $CUR_PATH/send_lark_message.py $LARK_WEBHOOK $ERIGON_SERVICE "$inform_info" $RESOLVED
          break
       fi
   done
fi