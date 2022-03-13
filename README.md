# Jets::Pipelines

Jets Pipelines adds a DSL for orchestrating a workflow using Jets Jobs. 

## Installation

Add this line to your Jets application's Gemfile:

```ruby
gem 'jets-pipelines', git: 'git@github.com:theablefew/jets-pipelines.git', require: 'pipelines'
```

And then execute:

    $ bundle install

#### Install PipelineJob

    $ jets install pipelines

This will create `app/jobs/pipeline_job.rb`. Jobs that inherit from PipelineJob receive all the helper methods and callbacks to function as a pipeline. 

## Usage


### A Simple Pipeline
```ruby
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
```

### The Job
```ruby
class TestJob < PipelineJob

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

```

### Run The Job
```ruby
TestJob.perform_now :do_something, {"Records"=>[{"messageId"=>"1e0bfe01-f9df-46c0-8d86-2fd898e4dee9", "receiptHandle"=>"AQEBgxVw0hjHeNKB1brir4hr0Fxvz4ERJIqd7bP/iHw82/+UUx/r4W0KG3FSiEA4A+Vk0oS8dT6W8be/Bn7eJjKspZfW2KzC0xzsCmS+BihySk1SX9FM5SW1rFd3bFWYtT6s7pOX2inaU/THtn7Envp5Rs+zehmNIspnLPZkf9h3RFSQk12xaVaOmCQnHtz9o8uKIXwMEwn5IhlJgC0DIuM1v8NZK8Hc65b4xpf09vf01LEA/XdXm24SjfJ0fl7ev2rBXtkMitAfNmKd8x0fcbG3O7H7wB+CIKR4+QvGcI6u9QuAdPU5MpIJ46niJmrtnIx70S5Go1paUYMa77ABBjFWoJkJHvHouuiohEQHdMrH1QSyabNBS2Nw2dikhBcXVtLQW4iH+xNXwLIVUxarAk9EHokh1iGWZsG91whmPaAl0t2Vdfo6Dcm0/6IgXhKcLFIw", "body"=>"{\"current_job\":[\"convert_data\",\"segment_1\"],\"pipeline\":{\"convert_data\":{\"segment_1\":{\"do_something\":{\"payload\":{\"something\":[\"goats\",\"turkeys\"]},\"input\":\"job_sqs\"}}}}}", "attributes"=>{"ApproximateReceiveCount"=>"1", "SentTimestamp"=>"1550605918693", "SenderId"=>"AIDAJTCD6O457Q7BMTLYM", "ApproximateFirstReceiveTimestamp"=>"1550605918704"}, "messageAttributes"=>{}, "md5OfBody"=>"3d635e69eb93fd184b47a31d460ca2b6", "eventSource"=>"aws:sqs", "eventSourceARN"=>"arn:aws:sqs:us-west-2:112233445566:demo-dev-List-3VJ13ADFT5VZ-Waitlist-X35N8JKWZTL3", "awsRegion"=>"us-west-2"}]}
```
### Output

```ruby
BEFORE: {"payload"=>{"something"=>["goats", "turkeys"]}, "input"=>"job_sqs"}
CURRENT JOB: {"payload"=>{"something"=>["goats", "turkeys", "cats"]}, "input"=>"job_sqs"}
THE MAIN CODE
AFTER: {"payload"=>{"something"=>["goats", "turkeys", "cats", "more cats", "peacocks"]}, "input"=>"job_sqs"}
```

## Callbacks

#### DSL helpers
`pipeline :name` Describes Pipeline

`segment :name` Describes workflow that ends in END OF QUEUE

`job :name` 

`watch :name`

`before(:callback_name)`

`after(:callback_name)`

#### Job 
`run_callbacks(:callback_name)`
Runs the callbacks defined by `:callback_name` via the Pipeline DSL




## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/esmarkowski/jets-pipelines. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/esmarkowski/jets-pipelines/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jets::Pipelines project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/esmarkowski/jets-pipelines/blob/master/CODE_OF_CONDUCT.md).
