module Pipelines
    class Segment
        include Pipelines::Registry

        attr_accessor :name, :parent

        def initialize(name, parent: nil)
            @name = name
            @parent = parent
            # Pipeline.registry[self.as_json] = self.registry
        end

        def job(name, input: nil, destination: nil , output: nil, &block)
            job = Job.new(name, input: input, destination: destination, output: output, parent: [parent, self.name])
            job.instance_eval(&block) if block_given?
            registry[job.name] = job
        end

        def watch(name, input: nil, every: nil, destination: nil, output: nil, &block)
            watch = Watch.new(name, every: every, input: input, destination: destination, output: output, parent: [parent, self.name])
            watch.instance_eval(&block) if block_given?
            registry[watch.name] = watch
        end

        def build
            jobs.deep_transform_values do |value|
                value.build
            end
        end

        alias_method :jobs, :registry
    end
end
