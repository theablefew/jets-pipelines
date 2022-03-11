class PipelineJob < ApplicationJob
    include PipelineHelper
    include Jets::AwsServices
    include AwsEventHelper

    END_OF_QUEUE = "end_of_queue"
end