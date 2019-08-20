require 'pco_api'

module Lita
  module Handlers
    class ResourcesApiClient < Handler
      attr_reader :api
      config :auth_token, default: ENV['AUTH_TOKEN']
      config :auth_secret, default: ENV['AUTH_SECRET']

      route(/list\s+approval\s+groups/i, :respond_with_approval_groups, command: true)

      def respond_with_approval_groups(response)
        robot.chat_service.send_attachment(response.message.source.room_object, formatted_approval_groups)
      end

      def api
        @api = PCO::API.new(basic_auth_token: config.auth_token, basic_auth_secret: config.auth_secret)
      end

      def fetch_approval_groups
        api.resources.v2.resource_approval_groups.get
      end

      def formatted_approval_groups
        groups = fetch_approval_groups['data']
        [
          {
            "text": "Choose from this list of Resource Approval Groups for your Organization:",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "callback_id": "approval_group_selection",
            "actions": [
              {
                "name": "groups_list",
                "text": "Pick an approval group...",
                "type": "select",
                "options": groups.map { |group| { "text": group['attributes']['name'], "value": group['id'] } }
              }
            ]
          }
        ]
      end


      Lita.register_handler(self)
    end
  end
end
