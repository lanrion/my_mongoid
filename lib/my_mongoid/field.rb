module MyMongoid
  class Field
    attr_reader :name, :options
    def initialize(name, options = {})
      @name    = name
      @options = options
    end

    def method_missing(name, opts = {})
      value = @options[name.to_sym]
      if value.nil?
        super
      else
        self.class_eval do
          define_method(name){value}
        end
        value
      end
    end
  end
end
