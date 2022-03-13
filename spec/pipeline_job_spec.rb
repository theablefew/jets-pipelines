RSpec.describe "PipelineJob" do

    let(:pipeline) do
        Pipelines.pipeline :convert_data do

            segment :segment_1 do

                job :do_something, input: 'job_sqs' do
                
                    before(:create) do 
                        # execute code as proc
                        puts "BEFORE: #{current_job.to_hash}"
                        puts "OUTER VAR #{@outside_var}"
                        current_job.payload.something << "cats"
                    end

                    after(:create) do 
                        current_job.payload.something << "peacocks"
                        puts "RESULT MODIFICATION #{@something_instance}"
                        puts "AFTER: #{current_job.to_hash}"
                    end
                end

            end

        end
    end




    let(:job) do

        class TestJob < Jets::Job::Base
            include PipelineHelper

            def do_something
                # ap Pipelines.registry.dig(*event[:current_job]).jobs[meth].callbacks
                @outside_var = "outside"

                run_callbacks(:create) do
                    puts "CURRENT JOB: #{current_job.to_hash}"
                    some_var = "something_to_do"
                    current_job.payload.something << "more cats"
                    @something_instance = current_job.payload.something.select { |x| x =~ /cats/ }
                    puts "THE MAIN CODE"
                    sucess = true
                end

            end
        end

        TestJob
    
    end

    before { pipeline }

    context "pipeline" do

        it 'performs' do
            # ap Pipelines.registry.dig(:convert_data, :segment_1) #.find { |key, pipe| puts pipe;  pipe.to_s == "convert_data" }
            event = json_file("spec/fixtures/sqs_event.json")
            job.perform_now(:do_something, event)
            # event = json_file("spec/fixtures/dumps/sqs/sqs_event.json")
            # job.perform_now(:do_something, {current_job: [:convert_data, :segment_1] , pipeline: {convert_data: {segment_1: {do_something: {input: 'job_sqs'}}}}} )
        end

        context "callbacks" do
            it 'can access instance variables' do
            end

            it 'can access instance methods' do
            end

            it 'runs before callbacks' do
            end

            it 'runs after callbacks' do
            end
        
            it 'can modifify payload' do
            end
        end


    end


end