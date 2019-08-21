require 'pco_api'
require 'uri'
require 'request_attributes'

module Lita
  module Handlers
    class ResourcesApiClient < Handler
      attr_reader :api
      config :auth_token, default: ENV['AUTH_TOKEN']
      config :auth_secret, default: ENV['AUTH_SECRET']
      # For slack interactive elements
      config :slack_verification_secret, default: ENV['SLACK_VERIFICATION_SECRET']

      http.post '/actions', :respond_with_action

      route(/list\s+approval\s+groups/i, :respond_with_approval_groups, command: true, help: {'list approval groups' => 'listing'})
      
      def respond_with_approval_groups(response)
        robot.chat_service.send_attachment(response.message.source.room_object, formatted_approval_groups)
      end

      def respond_with_action(request, response)
        payload = request_payload(request)
        if verify_request(payload.token)
          robot.trigger(payload.callback_id.to_sym, payload.attributes_hash)
          http.post payload.response_url, MultiJson.dump({"text": "Your request has been received...", "response_type": "in_channel"})
        end
      end

      def request_payload(request)
        RequestAttributes.new(request)
      end

      def api
        @api = PCO::API.new(basic_auth_token: config.auth_token, basic_auth_secret: config.auth_secret)
      end

      def fetch_approval_groups
        api.resources.v2.resource_approval_groups.get
      end

      def verify_request(token)
        token == config.slack_verification_secret
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
