module Lita
  module Handlers
    class ActionsHandler < Handler
      on :approval_group_selection, :subcribe_to_pending_approvals

      def subscribe_to_pending_approvals(payload)
        Lita.logger.info "#{payload}"
      end
    end
  end
end
