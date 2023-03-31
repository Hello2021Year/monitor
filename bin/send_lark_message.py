import sys
import requests
import time
import json

def generate_alert_message(service_name,text,level,status):
    """
    富文本类型
    :param title 标题，默认没有
    """

    content = []
    message=dict()
    message["tag"]="text"
    trigger_time=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    message["text"]="Status: {} \n".format(status) + "Service: {} \n".format(service_name) + "Description: {} \n".format(text) + "time: {}".format(trigger_time)
    tmp = []
    tmp.append(message)
    content.append(tmp)

    # title
    title=gen_message_title(level)

    data = {
        "msg_type": "post",
        "content": {
            "post": {
                "zh_cn": {
                    "title": title,
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

def gen_message_title(level):
    if level == "Fatal":
        return "服务运行异常告警通知"
    elif level == "Error":
        return "服务重启异常告警通知"
    elif level == "Info":
        return "服务由异常转为正常通知"


if __name__ == "__main__":
   lark_webhook=sys.argv[1]
   service_name=sys.argv[2]
   text=sys.argv[3]
   level=sys.argv[4]
   status=sys.argv[5]

   message=generate_alert_message(service_name,text,level,status)
   text=send_lark_message(lark_webhook,message)
   print(text)
