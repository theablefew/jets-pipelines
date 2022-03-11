module Pipelines
    module Mermaid
        class Pipeline
        
        attr_accessor :pipeline, :name
        
        def initialize(name, pipeline)
            @name = name
            @pipeline = pipeline
        end
        
        def segments
            pipeline.collect do |segment|
                Mermaid::Segment.new(*segment)
            end
        end
        
        def to_sequence_diagram
            <<~SEQUENCE_DIAGRAM
            sequenceDiagram
                #{segments.map(&:mermaid_participants).join("\n")}
                #{segments.map(&:mermaid_sequence).join("\n")}
            SEQUENCE_DIAGRAM
        end
        
        def to_flowchart
            <<~FLOWCHART
            flowchart LR
                classDef sqs fill:#f090b3;
                classDef endqueue fill:#ff5500;
                #{segments.map(&:to_flowchart).join("\n")}
                
                class end_of_queue endqueue;
            FLOWCHART
        end
        
        def sequence
            segments.map { |d| "#{d.name}->>#{d.destination}: #{d.payload.class}" }
        end
        
        end
    end
    
end
