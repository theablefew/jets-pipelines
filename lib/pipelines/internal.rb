module Pipelines
    module Internal

        extend ActiveSupport::Concern

        included do
            delegate :pipelines,
            to: :configuration
        end

        class_methods do


            def configuration
                @configuration ||= Configuration.new
            end

        end


    end
end