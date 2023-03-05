import sys
import requests
import time

def generate_alert_message(service_name,text,level,status):
    title=gen_message_title(leve)
    status="<strong>Status: {}</strong>".format(status)
    service_name="<strong>Service: {}</strong>".format(service_name)
    description="<strong>Description:</strong> {}".format(text)
    trigger_time=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    message =title + "\n" + status+ "\n" + service_name + "\n" + description + "\n" + "<strong>time:</strong>" + trigger_time
    print(message)
    return message

def gen_message_title(level):
    if level == "Fatal":
        return "服务运行异常告警通知"
    elif level == "Error":
        return "服务重启异常告警通知"
    elif level == "Info":
        return "服务由异常转为正常通知"

if __name__ == "__main__":
   bot_token=sys.argv[1]
   chat_id=sys.argv[2]
   service_name=sys.argv[3]
   text=sys.argv[4]
   level=sys.argv[5]
   status=sys.argv[6]

   message=generate_alert_message(service_name,text,level,status)
   send_text = 'https://api.telegram.org/bot' + bot_token + '/sendMessage?chat_id=' + chat_id + '&parse_mode=HTML&text=' + message
   print(send_text)
   response = requests.post(send_text)
   print(response.json())
