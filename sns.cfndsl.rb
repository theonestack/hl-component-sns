CloudFormation do

  default_tags = external_parameters.fetch(:default_tags, nil)

  tags = []
  default_tags.each do |key, value|
    tags << {Key: key, Value: value}
  end unless default_tags.nil?

  topics = external_parameters.fetch(:topics, nil)

  if (defined? topics and (not topics.nil?))
    topics.each do |key, config|
      config = {} if config.nil?
      resource_name = "#{key.gsub('_', '').gsub('-', '').capitalize}"

      SNS_Topic(resource_name) do
        if config.key? 'topic_name'
          TopicName config['topic_name']
        end

        if config.key? 'display_name'
          DisplayName config['display_name']
        end

        if config.key? 'content_based_deduplication'
          ContentBasedDeduplication config['content_based_deduplication']
        end

        if config.key? 'fifo_topic'
          FifoTopic config['fifo_topic']
        end

        Tags tags unless tags.empty?

      end

      if config.key? 'subscriptions'

        config['subscriptions'].each_with_index do |sub, ix|

          SNS_Subscription("#{resource_name}s#{ix}") do

            endpoint = sub['endpoint']
            if sub['protocol'] == 'lambda'
              if endpoint.include? '.' and endpoint.split('.').size == 2
                endpoint = FnGetAtt(endpoint.split('.')[1], 'Arn')
              elsif (not endpoint.start_with? 'arn:aws:lambda:')
                # if arn is not given and not referencing lambda, we assume lambda is given as function name
                # within same account and region
                endpoint = FnJoin('', ['arn:aws:lambda:', Ref('AWS::Region'), ':', Ref('AWS::AccountId'), ':function:slackMessage'])
              end
            end

            TopicArn Ref(resource_name)
            Protocol sub['protocol']
            Endpoint endpoint

          end
        end

      end

      if config.key? 'output' and config['output']
        Output("Topic#{resource_name}Arn") do
          Value Ref(resource_name)
        end
      end

    end
  else
    SNS_Topic('DefaultTopic') do
      Tags tags unless tags.empty?
    end
    Output('TopicDefaultArn') do
      Value Ref('DefaultTopic')
    end
  end

end