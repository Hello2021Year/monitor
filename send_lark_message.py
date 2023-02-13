import sys
import requests
import time
import json

def generate_alert_message(service_name,text,level):
    """
    富文本类型
    :param title 标题，默认没有
    """

    content = []
    message=dict()
    message["tag"]="text"
    trigger_time=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    message["text"]="Staus: {} \n".format(level) + "Service: {} \n".format(service_name) + "Description: {} \n".format(text) + "Trigger_time: {}".format(trigger_time)
    tmp = []
    tmp.append(message)
    content.append(tmp)

    data = {
        "msg_type": "post",
        "content": {
            "post": {
                "zh_cn": {
                    "title": "服务异常告警通知",
                    "content": content
                },
            }
        }
    }

    return json.dumps(data)

def send_lark_message(url,message):
    headers = {
                'Content-Type': 'application/json'
              }

    response = requests.request("POST", url, headers=headers, data=message)
    return response.text




if __name__ == "__main__":
   lark_webhook=sys.argv[1]
   service_name=sys.argv[2]
   text=sys.argv[3]
   level=sys.argv[4]

   message=generate_alert_message(service_name,text,level)
   text=send_lark_message(lark_webhook,message)
   print(text)
