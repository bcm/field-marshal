require 'excon'
require 'platform-api'

module FieldMarshal
  module Deployers
    class Heroku
      include Virtus.value_object(strict: true)

      attribute :app_name,  String
      attribute :api_token, String

      def api
        @api ||= begin
          begin
            PlatformAPI.connect_oauth(api_token)
          rescue Excon::Errors::Unauthorized
            raise ConfigError, "Access to Heroku app denied"
          end
        end
      end

      def app
        @app ||= api.app.info(app_name)
      end

      def turn_on_maintenance_mode
        api.app.update(app_name, maintenance: true)
      end
    end
  end
end
