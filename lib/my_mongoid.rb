require "my_mongoid/version"
require "active_support/core_ext"
require "active_model"

require 'pry-rails'

module MyMongoid

  attr_accessor :models

  module Document
    extend ActiveSupport::Concern

    attr_accessor :attributes

    def self.included(klass)

      klass.module_eval do
        extend ClassMethods
        field :_id, :as => :id, :default => rand()
        MyMongoid.models = klass
      end
    end

    def initialize(attrs = {})
      raise ArgumentError if !attrs.is_a?(Hash)
      @attributes = {}
      process_attributes(attrs)
      process_default_value(attrs)
      yield self if block_given?
    end

    def process_attributes(attrs)
      attrs.each_pair do |name, value|
        raise MyMongoid::UnknownAttributeError if !self.respond_to?(name)
        validate_value_type(name, value)
        send("#{name}=", value)
      end
    end
    alias_method :attributes=, :process_attributes

    def process_default_value(known_attrs)
      fields = self.class.fields
      uninit_attr_keys = fields.keys - known_attrs.keys
      uninit_fields    = uninit_attr_keys.collect{|attr_key| fields[attr_key]}

      uninit_fields.each do |field|
        validate_value_type(field.name, field.options[:default])
        send("#{field.name}=", field.options[:default]) if !field.options[:default].nil?
      end
    end

    def validate_value_type(attr_name, attr_value)
      fields = self.class.fields
      field  = fields[attr_name.to_s]
      define_type = field.options[:type]
      return true if define_type.nil?
      attr_value_type = attr_value.class
      raise MyMongoid::MismatcheTypeError if attr_value_type != define_type
      true
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

      def is_mongoid_model?
        true
      end

      def field(name, options={})
        name = name.to_s
        @fields ||= {}
        raise MyMongoid::DuplicateFieldError if @fields.has_key?(name)
        @fields[name] = MyMongoid::Field.new(name,options)

        define_method(name) do
          read_attribute(name)
        end

        define_method("#{name}=") do |value|
          write_attribute(name, value)
        end

        if alias_name = options[:as]
          alias_name = alias_name.to_s
          self.module_eval do
            alias_method alias_name, name
            alias_method "#{alias_name}=", "#{name}="
          end
        end

      end

      def fields
        @fields
      end
    end
  end

  def self.models=(model)
    @models ||= []
    @models << model
  end

  def self.models
    @models
  end

  class Field
    attr_reader :name, :options
    def initialize(name,options)
      @name = name
      @options = options
    end

    # def method_missing(name, opts={})
    #   define_method(name) do
    #     @options[name.to_sym]
    #   end
    #   super
    # end
  end

end

class MyMongoid::DuplicateFieldError < RuntimeError
end

class MyMongoid::UnknownAttributeError < RuntimeError
end

class MyMongoid::MismatcheTypeError < RuntimeError
end
