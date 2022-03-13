module Pipelines
    module Mermaid
        class Segment
        attr_accessor :segment
        attr_accessor :name
        delegate_missing_to :@segment
        def initialize(name, segment)
            @name = name.to_s
            @segment = Hashie::Mash[segment]
        end
            
        def next_job
            segment.next_job || "end_of_queue"
        end
        
        def payload
            segment.payload || {}
        end
        
        
        def mermaid_participants
            ["participant #{name} as #{name.titleize}",
            "participant #{destination} as #{destination.to_s.titleize}"]
    #       "class #{destination_queue} sqs;"]
        end
        
        def mermaid_sequence
            seq = ["#{name}->>#{destination}: #{payload.to_json.gsub(/","/, '",<br>"')}"]
            unless next_job == "end_of_queue"
            seq << "#{destination}-->>#{next_job}: SQS Event" 
    #         seq << "class #{destination_queue} sqs;"
            end
            seq
    
        end
    
        def to_flowchart
            seq = ["#{name}(#{name.titleize})-->|\"#{payload.class}\"|#{destination}"]
            unless next_job == "end_of_queue"
            seq << "#{destination}(#{destination})-->|SQS Event|#{next_job}(#{next_job.titleize})"
            seq << "class #{destination} sqs;"
            else
            seq << ["#{name}(#{name.titleize})-->#{destination}"]
            end
        end
        
    
        end
    end
end
    