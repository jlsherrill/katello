module Actions
  module Katello
    module Host
      class AutoAttachSubscriptions < Actions::EntryAction
        middleware.use ::Actions::Middleware::RemoteAction

        def plan(host)
          action_subject host.subscription_aspect
          plan_action(::Actions::Candlepin::Consumer::AutoAttachSubscriptions, host.subscription_aspect)
        end

        def finalize
          ::Katello::Pool.import_all
        end
      end
    end
  end
end
