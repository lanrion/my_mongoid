# encoding: utf-8
module MyMongoid
  # Defines behaviour for persistence operations that create new documents.
  module Sessions
    extend ActiveSupport::Concern

    class << self

      def default
        @session ||= create_session
      end
    end

    def collection
      self.class.mongo_session[collection_name]
    end

    def collection_name
      self.class.collection_name
    end

    module ClassMethods
      def mongo_session
        @session_default ||= Sessions.default
      end

      def collection
        mongo_session[collection_name]
      end
    end

    private

      def self.create_session(config={})
        session = Moped::Session.new(config["host"]||["localhost:27017"])
        session.use(config["database"]||"my_mongoid")
        if authenticated?(config)
          session.login(config[:username], config[:password])
        end
        session
      end

      def self.authenticated?(config)
        config.has_key?(:username) && config.has_key?(:password)
      end

  end
end
