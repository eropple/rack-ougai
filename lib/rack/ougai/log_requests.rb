require 'time'

module Rack
  module Ougai
    class LogRequests
      def initialize(app, logger = nil, local: false)
        @app = app
        @logger = logger
        @local = local
      end

      def call(env)
        start_time = Time.now
        status, headers, _body = @app.call(env)
      ensure
        logger = @logger || env[RACK_LOGGER]
        logger.info('http', create_log(start_time, env, status, headers))
      end

      private

      def create_log(start_time, env, status, headers)
        end_time = Time.now

        ret = {
          time: @local ? start_time : start_time.utc,
          usec: (end_time.to_f - start_time.to_f) * 10**6,
          remote_addr: env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"],
          method: env[REQUEST_METHOD],
          path: env[PATH_INFO],
          query: env[QUERY_STRING],
          status: status.to_i,
        }

        request_id = env['HTTP_X_REQUEST_ID']
        ret[:request_id] = request_id unless request_id.nil?
        content_version = headers['Content-Version']
        ret[:content_version] = content_version unless content_version.nil?

        ret
      end

    end
  end
end
