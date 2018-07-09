CfhighlanderTemplate do

  Name 'sns'

  if (ENV.key? 'CFHIGHLANDER_SNS_COMPONENT_TEST' and ENV['CFHIGHLANDER_SNS_COMPONENT_TEST'])
    # overriding use_default_lambda_subscribers changes the binding, and sets empty nil value
    # to this variable, hence different var name for same purpose
    test = true
  end

  if use_default_lambda_subscribers or test
    LambdaFunctions 'lambda_subscribers_default'
  end

  Parameters do
    if use_default_lambda_subscribers or test

      # this is required parameter, webhook url
      ComponentParam 'SlackIncomingWebHook', '', noEcho: true

      # if not channel supplied, message will be posted to whatever is configured on the hook
      ComponentParam 'SlackChannel', ''

      # if no username supplied, lambda shall use whatever is configured on the hook
      ComponentParam 'SlackUsername', ''
    end
  end

end
