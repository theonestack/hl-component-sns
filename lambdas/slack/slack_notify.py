import json
import os
import requests
import yaml

def lambda_handler(event, context):
    
    url = os.environ['slack_incoming_hook']
    
    headers = {
        'Cache-Control': "no-cache"
    }
    
    message = event['Records'][0]['Sns']['Message']
    
    try:
        message_obj = json.loads(message)
        message = yaml.dump(message_obj,
                            default_flow_style = False,
                            allow_unicode = True,
                            encoding = None
                            )
        message = f"\n```\n{message}```\n\n"
    except:
        print("Couldn't decode message as json")
    topic = event['Records'][0]['Sns']['TopicArn']
    print(f"Mesage from topic {topic}:\n{message}")
    
    slack_payload = {
        'text': message
    }

    if os.environ.get('slack_channel', False):
        slack_payload['channel'] = os.environ['slack_channel']
    
    if os.environ.get('slack_username', False):
        slack_payload['username'] = os.environ.get('slack_username')
    
    if os.environ.get('icon_emoji', False):
        slack_payload['icon_emoji'] = os.environ.get('icon_emoji')
    
    response = requests.request("POST", url, data=json.dumps(slack_payload), headers=headers)
    print(response.text)
    return 'OK'
