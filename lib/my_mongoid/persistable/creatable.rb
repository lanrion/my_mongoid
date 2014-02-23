# encoding: utf-8
module MyMongoid
  module Persistable

    # Defines behaviour for persistence operations that create new documents.
    module Creatable
      extend ActiveSupport::Concern

      def insert(attrs={}, options={})
        new_attrs = attrs.blank? ? attributes : attrs
        collection.insert(new_attrs)
      end
      alias_method :save, :insert

      def create(attrs={}, &block)
        new_attributes = attributes.merge(attrs)
        insert(new_attributes)
      end

    end
  end
end
