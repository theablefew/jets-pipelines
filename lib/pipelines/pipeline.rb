module Pipelines
    class Pipeline
        include Pipelines::Registry
        attr_accessor :name

        def initialize(name)
            @name = name
            Pipelines.registry[name] = self.registry
        end

        def segment(name, &block)
            segment = Segment.new(name, parent: self.name)
            segment.instance_eval(&block)
            registry[segment.name] = segment
        end

        def build
            registry.deep_transform_values do |value|
                value.build
            end
        end

        def to_mermaid
            build.map do |seg|
                <<~MARKDOWN
                    ### #{seg.first}
                    ```mermaid
                    #{Mermaid::Pipeline.new(*seg).to_sequence_diagram}
                    ```
                MARKDOWN
            end.join("\n")
        end

        alias_method :segments, :registry

    end
end
