![cftest](https://github.com/theonestack/hl-component-sns/actions/workflows/rspec.yaml/badge.svg)

### SNS Cfhighlander component

- Create SNS topics with subscriptions
- Optionally render outputs 


### Requirements

If you are using default subscription lambdas (at this point only slack), you'll need either
pip or docker on your path in order to install dependencies. 


### Parameters

TBD

### Configuration

SNS Component will create single sns topic if no topics are defined through configuration

Component is equipped with lambda function that forwards messages from sns topic to Slack channel.
This functionality is disabled by default. You can enable it by supplying following configuration element:

```bash
use_default_lambda_subscribers: true
``` 

If this option is enabled, component will have parameters for slack webhook exposed. 

You configure sns topics and possible email/lambda/http destinations


### Outputs

TBD

### Sample Usage

```yaml
# enable slack notifier
##
## Example configuration for component
##
topics:
  default_sns_topic:
    topic_name: production_alarms
    display_name: Production Alarms
    output: true  # topic arn will be created as 'Defaultsnstopic' output (capatilized, with removed underscores and slashes)
                  # set to false if you don't need this output (e.g. more than 60 topics / outputs)
    subscriptions:
      # Check https://docs.aws.amazon.com/sns/latest/api/API_Subscribe.html for
      # valid protocols. Type translates to protocol, and destination to endpoint
      # http and https
      - protocol: http
        endpoint: https://www.myapiwebhookreciever.com
      - protocol: https
        endpoint: https://www.myapiwebhookreciever.com

      - protocol: email
        endpoint: email@example.com

      # endpoint for lambda cen be
      # 1. reference to key under lambda_subscribers
      - protocol: lambda
        endpoint: lambda_subscribers_default.slackMessage
      # 2. of arn type
      - protocol: lambda
        endpoint: arn:aws:lambda:us-east-1:123456789012:function:SnsSlackMesasge
      # 3. by default if there is no key, and is not in arn form, it will just try to use function
      # with given name within same account and region as sns topic
      # This will evaluate to FnJoin('',['arn:aws:lambda:', Ref('AWS::Region'), ':', Ref('AWS::Account'), ':function:slackMessage' ])
      - protocol: lambda
        endpoint: slackMessage

```

