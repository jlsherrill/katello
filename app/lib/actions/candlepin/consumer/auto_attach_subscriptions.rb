module Actions
  module Candlepin
    module Consumer
      class AutoAttachSubscriptions < Candlepin::Abstract
        input_format do
          param :uuid, String
        end

        def plan(subscription_aspect)
          plan_self(:uuid => subscription_aspect.uuid)
        end

        def run
          ::Katello::Resources::Candlepin::Consumer.refresh_entitlements(input[:uuid])
        end
      end
    end
  end
end
