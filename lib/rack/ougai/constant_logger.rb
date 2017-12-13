require 'ougai'

module Rack
  module Ougai
    class ConstantLogger
      def initialize(app, logger)
        raise "logger must be an Ougai::Logging (got: #{logger.class.name})." unless logger.is_a?(::Ougai::Logging)

        @app = app
        @logger = logger
      end

      def call(env)
        env[RACK_LOGGER] = @logger
        @app.call(env)
      end
    end
  end
end
