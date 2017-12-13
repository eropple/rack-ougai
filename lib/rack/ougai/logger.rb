require 'ougai'

module Rack
  module Ougai
    class Logger
      def initialize(app, level = ::Logger::INFO)
        @app = app
        @level = level
      end

      def call(env)
        logger = ::Ougai::Logger.new(env[RACK_ERRORS])
        logger.level = @level

        env[RACK_LOGGER] = logger
        @app.call(env)
      end
    end
  end
end
