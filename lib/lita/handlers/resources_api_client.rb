require 'pco_api'

module Lita
  module Handlers
    class ResourcesApiClient < Handler
      attr_reader :api
      config :auth_token, default: ENV['AUTH_TOKEN']
      config :auth_secret, default: ENV['AUTH_SECRET']

      route(/list\s+approval\s+groups/i, :respond_with_approval_groups, command: true)

      def respond_with_approval_groups(response)
        response.reply(MultiJson.dump(formatted_approval_groups))
      end

      def api
        @api = PCO::API.new(basic_auth_token: config.auth_token, basic_auth_secret: config.auth_secret)
      end

      def fetch_approval_groups
        api.resources.v2.resource_approval_groups.get
      end

      def formatted_approval_groups
        render_template('approval_groups', groups: fetch_approval_groups)
      end


      Lita.register_handler(self)
    end
  end
end
