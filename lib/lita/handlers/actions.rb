module Lita
  module Handlers
    class Actions < Handler
      on :approval_group_selection, :subscribe_to_pending_approvals

      def subscribe_to_pending_approvals(payload)
        Lita.logger.info "#{payload}"
      end

      Lita.register_handler(self)
    end
  end
end
