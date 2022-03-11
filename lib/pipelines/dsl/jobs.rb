module Pipelines::Dsl
    module Jobs
        extend ActiveSupport::Concern

        class_methods do


            def input
            end

            def destination
            end

            def output
            end

            def payload
            end


            def hook(&block)
                hook.instance_eval(&block)
            end






        end

    end
end