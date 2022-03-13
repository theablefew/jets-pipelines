module Pipelines
    class Watch

        include Pipelines::Registry

        attr_accessor :name, :at, :input, :every, :destination, :output, :payload, :hook, :parent

        def initialize(name, every: nil, at: nil, input: nil, destination: nil , output: nil, parent: nil)
            @name = name
            @parent = parent
            @every = every
            @at = at
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
                at: @at,
                payload: @payload,
            }
        end

    end
end