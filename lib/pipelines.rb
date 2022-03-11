# frozen_string_literal: true
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup 

require 'jets'
require 'ap'
require 'active_support'
require 'hashie'
require 'active_model'
require_relative "pipelines/version"

module Pipelines
  END_OF_QUEUE = :end_of_queue
  include Pipelines::Registry

  def self.pipeline(name, &block)
      pipeline = Pipeline.new(name)
      pipeline.instance_eval(&block)
      pipeline
  end

  def self.build
      Pipelines.registry.deep_transform_values do |value|
          value.build
      end
  end


end

require_relative "pipelines/turbine" if defined?(Jets)

