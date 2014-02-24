module MyMongoid

  module Document
    extend ActiveSupport::Concern
    include Sessions
    include Persistable::Creatable
    include Persistable::Deletable
    include Queryable::Finder

    attr_accessor :attributes

    included do |klass|
      klass.module_eval do
        extend ClassMethods
        field(:_id,
              :as      => :id,
              :default => ->{ BSON::ObjectId.new },
              :type    => BSON::ObjectId )
        MyMongoid.models = klass
      end
    end

    def initialize(attrs = {})
      raise ArgumentError if !attrs.is_a?(Hash)
      @new_record = true
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
        default_opt   = field.options[:default]
        default_value = default_opt.respond_to?(:call) ? default_opt.call : default_opt
        send("#{field.name}=", default_value) if default_opt.present?
      end
    end

    def validate_value_type(attr_name, attr_value)
      return true if attr_value.blank?
      fields = self.class.fields
      field  = fields[attr_name.to_s]
      define_type = field.options[:type]
      return true if define_type.blank?
      attr_value_type = attr_value.class
      if attr_value_type == Proc
        attr_value_type = attr_value.call.class
      end
      raise MyMongoid::MismatcheTypeError if attr_value_type != define_type
      true
    end

    def read_attribute(attr_name)
      @attributes[attr_name].to_s
    end

    def write_attribute(attr_name, new_attr_value)
      validate_value_type(attr_name, new_attr_value)
      @attributes[attr_name] = new_attr_value
    end

    def new_record?
      @new_record ||= false
    end

    def bson_id
      BSON::ObjectId.mongoize(id)
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

      def collection_name
        self.to_s.tableize
      end

      def documents
        collection.find
      end

    end
  end

end
