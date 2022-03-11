module Pipelines
    class Configuration

        attr_reader(
            :callback_names,
            :pipelines,
            :segments
            :jobs,
            :watches
        )

        def initialize
            @pipelines = Registry.new("Pipeline")
        end

    end
end