module Pipelines::Registry
    extend ActiveSupport::Concern
    included do
        @registry = ActiveSupport::HashWithIndifferentAccess.new
    end

    class_methods do
        def registry
            @registry
        end
    end

    def registry
        @registry ||= ActiveSupport::HashWithIndifferentAccess.new
    end
end
