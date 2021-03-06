module Pipelines
    class Job
        include Pipelines::Registry
        attr_accessor :name, 
                      :input, 
                      :destination, 
                      :output, 
                      :payload, 
                      :hook, 
                      :parent,
                      :context,
                      :callbacks

        def initialize(name, input: nil, destination: nil , output: nil, parent: nil, payload: nil, context: nil)
            @name = name
            @parent = parent
            @payload = payload
            @input = input
            @context = {}
            @callbacks = {}
            @destination = destination || Pipelines::END_OF_QUEUE
            @output = output || :sqs_event_payload
        end

        def payload(arg)
            @payload = arg
        end

        def context(arg)
            @context = arg
        end

        def input(arg)
            @input = arg
        end

        def destination(arg)
            @destination = arg
        end

        def output(arg)
            @output = arg
        end

        def before(callback, &block)
            @callbacks[callback] ||= {}
            @callbacks[callback][:before] = block 
        end

        def after(callback, &block)
            @callbacks[callback] ||= {}
            @callbacks[callback][:after] = block
        end

        def hook(&block)
            hook = Hook.new
            hook.instance_eval(&block) if block_given?
        end

        def next_job
            Hash[@destination, Pipelines.build.dig(*@parent)[@destination]]
        end

        def build
            HashWithIndifferentAccess.new(
                input: @input,
                destination: @destination,
                output: @output,
                payload: @payload,
                context: @context,
                parent: @parent
            )
        end

    end
end
