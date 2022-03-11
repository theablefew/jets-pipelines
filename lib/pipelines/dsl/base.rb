module Pipelines::Dsl
    module Base


            def pipeline(name, &block)
                pipeline = Jets::Pipeline.new(name)
                pipeline.instance_eval(&block)
                pipeline.save
            end

            def segment(name, &block)

            end

            def job(name, input: nil, destination: nil, output: END_OF_QUEUE, &block)
                job = Jets::Job.new(name, input: input, destination: destination, output: output)
                job.instance_eval(&block)
                job.save
            end

        end
    end
end