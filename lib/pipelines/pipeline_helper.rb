module PipelineHelper
   
    def current_job
        pipeline[meth.to_sym]
    end
  
    def pipeline
        @pipeline ||= Hashie::Mash.new(sqs_event_payload[:pipeline])
    end
  
    def next_job
        pipeline[current_job.destination]
    end

    def callbacks
        Pipelines.registry.dig(*current_job[:parent]).jobs[meth].callbacks
    end

    def run_callbacks(callback, with_pipeline: nil)

        @pipeline = Hashie::Mash.new(with_pipeline.as_json) if with_pipeline


        self.instance_exec(&callbacks[callback][:before]) if callbacks.dig(callback, :before).present?
        yield if block_given?
        self.instance_exec(&callbacks[callback][:after]) if callbacks.dig(callback, :after).present?
    end

    ## pipeline_output
    # @param [Object] event (e.g. Promise, Pipeline, Object, String, etc)
    # @param [String] service AWS Service (e.g. sqs, sns)
    ## additional_attributes (e.g. {queue_url: "queue_url", message_body: "message_body"}) 
    # @param [String] destination Path to logical stack queue url (e.g. "destination_queue")
    # @return [Object]
    #
    # Examples:
    # Send to SQS with specific destination
    #   pipeline_output(event, service: "sqs", destination: "wallets/my_fav_wallet_queue")
    #
    # Use current_job destination
    #   pipeline_output(event, service: "sqs", destination: current_job.destination)
    #
    # Default to SQS
    #   event = {payload: "goose"}
    #   pipeline_output(event, destination: current_job.destination)
    #
    # Default destination if event responsds to destination or has key "destination"
    #   event = {payload: "goose", destination: "destination_queue"}
    #   pipeline_output(event)
    #
    #
    # event = {payload: "goose", destination: "destination_queue"}
    # pipeline_output(event, service: :sns)
  
    def pipeline_output(event, service: :sqs, **additional_attributes)
        Jets::Pipeline::Output.to_service(service, event, additional_attributes)
    end
  
  end
  