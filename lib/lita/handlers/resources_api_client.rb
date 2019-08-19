module Lita
  module Handlers
    class ResourcesApiClient < Handler
      attr_reader :api

      route(/list\s+approval\s+groups/i, :respond_with_approval_groups, command: true)

      def respond_with_approval_groups(response)
        response.reply(formatted_approval_groups)
      end

      def api
        @api ||= Lita::Handlers::PcoApiClient.new(robot).api
      end

      def fetch_approval_groups
        @api.resources.v2.resource_approval_groups.get
      end

      def formatted_approval_groups
        render_template('approval_groups', groups: fetch_approval_groups)
      end


      Lita.register_handler(self)
    end
  end
end
