module Pipelines
    class Watch

        include Pipelines::Registry

        attr_accessor :name, :input, :every, :destination, :output, :payload, :hook, :parent

        def initialize(name, every: nil, input: nil, destination: nil , output: nil, parent: nil)
            @name = name
            @parent = parent
            @every = every
            @input = input
            @destination = destination || Pipelines::END_OF_QUEUE
            @output = output || :sqs_event_payload
        end

        def next_job
            Hash[@destination, Pipelines.build.dig(*@parent)[@destination]]
        end

        def build
            {
                input: @input,
                destination: @destination,
                output: @output,
                every: @every,
                payload: @payload,
            }
        end

    end
end