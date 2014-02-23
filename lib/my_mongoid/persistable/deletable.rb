# encoding: utf-8
module MyMongoid
  module Persistable

    # Defines behaviour for persistence operations that delete documents.
    module Deletable
      extend ActiveSupport::Concern

      def delete
        collection.find("_id" => bson_id).remove
      end
      alias_method :remove, :delete

      module ClassMethods
        def delete_all
          documents.remove_all
        end
        alias_method :destroy_all, :delete_all
        alias_method :remove, :delete_all
      end

    end

  end
end
