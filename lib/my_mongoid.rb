require "my_mongoid/version"
require "active_support/core_ext"
require "active_model"
require "my_mongoid/exceptions"
require "my_mongoid/field"
require "my_mongoid/document"

require 'pry-rails'

module MyMongoid

  attr_accessor :models

  def self.models=(model)
    @models ||= []
    @models << model
  end

  def self.models
    @models
  end

end

