require 'ougai'

module Rack
  module Ougai
    class AttachRequestID
      REQUEST_ID_KEY = 'HTTP_X_REQUEST_ID'

      def initialize(app, opts = {})
        @app = app
        @storage = opts[:storage] || proc { Thread.current }
      end

      def call(env)
        parent = env[Rack::RACK_LOGGER]
        request_id = env[REQUEST_ID_KEY]

        if request_id.nil?
          parent.warn "No request ID in storage (is Rack::RequestID in your middleware stack?)."
        end

        env[Rack::RACK_LOGGER] = parent.child(request_id: request_id)
        ret = @app.call(env)
        env[Rack::RACK_LOGGER] = parent

        ret
      end
    end
  end
end
