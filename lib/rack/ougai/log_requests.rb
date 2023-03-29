require 'time'

module Rack
  module Ougai
    class LogRequests
      CONTENT_TYPE_JSON = "application/json".freeze

      def initialize(app, logger = nil, local: false)
        @app = app
        @logger = logger
        @local = local
      end

      def call(env)
        start_time = Time.now
        status, headers, body_proxy = @app.call(env)
      ensure
        logger = @logger || env[RACK_LOGGER]
        logger.info('http', create_log(start_time, env, status, headers, body_proxy))
      end

      private

      def create_log(start_time, env, status, _headers, body_proxy)
        end_time = Time.now
        req = Rack::Request.new(env)

        ret = {
          time: @local ? start_time : start_time.utc,
          usec: end_time.usec - start_time.usec,
          remote_addr: env["HTTP_X_FORWARDED_FOR"] || env["REMOTE_ADDR"],
          method: env[REQUEST_METHOD],
          path: env[PATH_INFO],
          query: env[QUERY_STRING],
          status: status.to_i,
        }

        if show_request_body?(req)
          ret[:request_body] = req.body.string
          ret[:response_body] = body_proxy[0] if body_proxy
        end

        request_id = env['HTTP_X_REQUEST_ID']
        ret[:request_id] = request_id unless request_id.nil?

        ret
      end

      def show_request_body?(req)
        req.post? && req.content_type == CONTENT_TYPE_JSON && ENV["OUGAI_BODY_LOG"]
      end
    end
  end
end
