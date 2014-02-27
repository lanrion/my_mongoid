module MyMongoid
  class Configuration
    include Singleton
    attr_accessor :host, :database
  end
end
