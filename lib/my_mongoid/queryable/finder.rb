# encoding: utf-8
module MyMongoid
  module Queryable

    # Defines behaviour for persistence operations that create new documents.
    module Finder
      extend ActiveSupport::Concern

      module ClassMethods

        def count
          documents.count
        end

        alias_method :size, :count

        def find_by(attrs = {})
          new(collection.find(attrs).first.try(:to_hash))
        end

      end

    end
  end
end
