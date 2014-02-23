# encoding: utf-8
module MyMongoid
  module Persistable

    # Defines behaviour for persistence operations that create new documents.
    module Creatable
      extend ActiveSupport::Concern

      def insert(attrs={}, options={})
        new_attrs = attrs.blank? ? attributes : attrs
        collection.insert(new_attrs)
        @new_record = false
      end
      alias_method :save, :insert

      module ClassMethods
        def create(attrs={}, &block)
          doc = new(attrs)
          doc.save
          doc
        end
      end

    end
  end
end
