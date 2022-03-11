module Pipelines::Registry
    extend ActiveSupport::Concern
    included do
        @registry = {}
    end

    class_methods do
        def registry
            @registry
        end
    end

    def registry
        @registry ||= {}
    end
end
