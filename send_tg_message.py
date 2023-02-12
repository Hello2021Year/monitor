import sys
import requests
import time

def generate_alert_message(service_name,text,level):
    status="<strong>Status: {}</strong>".format(level)
    service_name="<strong>Service: {}</strong>".format(service_name)
    description="<strong>Description:</strong> {}".format(text)
    trigger_time=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
    message =status+ "\n" + service_name + "\n" + description + "\n" + "<strong>Trigger_time:</strong>" + trigger_time
    print(message)
    return message


if __name__ == "__main__":
   bot_token=sys.argv[1]
   chat_id=sys.argv[2]
   service_name=sys.argv[3]
   text=sys.argv[4]
   level=sys.argv[5]

   message=generate_alert_message(service_name,text,level)
   send_text = 'https://api.telegram.org/bot' + bot_token + '/sendMessage?chat_id=' + chat_id + '&parse_mode=HTML&text=' + message
   print(send_text)
   response = requests.post(send_text)
   print(response.json())
