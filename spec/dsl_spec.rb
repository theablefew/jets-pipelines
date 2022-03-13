RSpec.describe Pipelines do
    let(:pipeline) do
        Pipelines.pipeline :convert_data do

            segment :segment_1 do
        
                job :job_1, input: 's3', destination: :job_2
        
                job :job_2, input: 'job_2_sqs'

            end

            segment :segment_2 do
                watch :api, every: 10.minutes, destination: :job_3
                job :job_3 do
                    input 'job_3_sqs'
                    # hook do
                    #    # execute code as proc
                    # end
        
                    destination :job_4
                    output :sqs_event_payload
                end

                job :job_4, input: 'job_4_sqs' do
                    payload({some: 'data'})

                end
            end
        end
    end

    before { pipeline }

    context "pipeline" do

        it "has a registry" do
            expect(pipeline.registry).to be_a(Hash)
            expect(pipeline.registry).to include(:segment_1)
        end

        it "has a name" do
            expect(pipeline.name).to eq(:convert_data)
        end

    end

    context "job" do

        it "destination defaults to end_of_queue" do
            pipeline.build[:segment_1][:job_2][:destination] == "end_of_queue"
        end

    end

    context "watch" do

        it 'has time to run' do
            expect(pipeline.segments[:segment_2].jobs[:api].every).to eq(10.minutes)
            expect(pipeline.build[:segment_2][:api][:every]).to eq(10.minutes)
        end

    end

    it "has a global registry" do
        expect(Pipelines.registry).to include(:convert_data)
    end

    it 'defines end of queue' do
        expect(Pipelines::END_OF_QUEUE).to eq :end_of_queue
    end

    it 'builds' do
        expect(pipeline.build).to be_a(Hash)
    end


    context "has a heirarchy" do

        it "has segments" do
            expect(pipeline).to respond_to(:segments)
            expect(pipeline.segments).to include(:segment_1)
        end

        it "segments have jobs" do
            expect(pipeline.segments[:segment_1]).to respond_to(:jobs)
            expect(pipeline.segments[:segment_1].jobs).to include(:job_1)
        end
    end



    context 'next job' do
        let(:next_job) { pipeline.segments[:segment_1].jobs[:job_1].next_job }

        it 'map next job' do
            expect(next_job).to include(:job_2)
        end

        it 'has job details' do
            expect(next_job[:job_2][:input]).to eq('job_2_sqs')
            expect(next_job[:job_2][:destination]).to eq(Pipelines::END_OF_QUEUE)
            expect(next_job[:job_2][:output]).to eq(:sqs_event_payload)
            expect(next_job[:job_2][:payload]).to eq(nil)
        end
    end


    it 'outputs mermaid' do
        mermaid = <<~MERMAID
        ### segment_1
        ```mermaid
        sequenceDiagram
            participant job_1 as Job 1
        participant job_2 as Job 2
        participant job_2 as Job 2
        participant end_of_queue as End Of Queue
            job_1->>job_2: {}
        job_2->>end_of_queue: {}

        ```

        ### segment_2
        ```mermaid
        sequenceDiagram
            participant api as Api
        participant job_3 as Job 3
        participant job_3 as Job 3
        participant end_of_queue as End Of Queue
            api->>job_3: {}
        job_3->>end_of_queue: {}

        ```
        MERMAID
        # expect(pipeline.to_mermaid).to eq(mermaid)
        ap pipeline.build
    end


    it 'follows a sequence' do
      ap  pipeline.segments[:segment_1].jobs[:job_1].next_job
    end
end