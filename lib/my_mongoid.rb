require "my_mongoid/version"
require "active_support/core_ext"
require "active_model"
require "moped"

require 'my_mongoid/extensions/string'
require 'my_mongoid/extensions/object_id'

require "my_mongoid/exceptions"
require "my_mongoid/sessions"
require "my_mongoid/persistable/creatable"
require "my_mongoid/persistable/deletable"
require "my_mongoid/queryable/finder"
require "my_mongoid/field"
require "my_mongoid/document"

require "pry-rails"

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

