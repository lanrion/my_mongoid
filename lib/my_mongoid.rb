require "my_mongoid/version"
require 'pry-rails'

module MyMongoid

  attr_accessor :models

  module Document
    attr_accessor :attributes

    def self.included(klass)
      MyMongoid.models = klass
    end

    def initialize(attrs = {})
      raise ArgumentError if !attrs.is_a?(Hash)

      attrs.each_pair do |attr_name, attr_value|
        define_singleton_method(attr_name){attr_value}
      end

      @attributes = attrs
    end

    def read_attribute(attr_name)
      @attributes.fetch(attr_name)
    end

    def write_attribute(attr_name, new_attr_value)
      @attributes[attr_name]= new_attr_value
    end

    def new_record?
      true
    end

    module ClassMethods

    end
  end

  def self.models=(model)
    @models ||= Array.new
    @models << model
  end

  def self.models
    @models
  end

end
