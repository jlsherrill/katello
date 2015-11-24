module Actions
  module Katello
    module Subscription
      class Subscribe < Actions::Base
        middleware.use Actions::Middleware::KeepCurrentUser

        def plan(host, entitlements)
          pool_ids = []

          entitlements.each do |entitlement|
            pool_ids << entitlement[:pool].id
            plan_action(::Actions::Candlepin::Consumer::AttachSubscription, :uuid => host.subscription_aspect.uuid,
                        :pool_uuid => entitlement[:pool].cp_id, :quantity => entitlement[:quantity])
          end

          plan_self(:pool_ids => pool_ids)
        end

        def finalize
          ::Katello::Pool.where(:id => input[:pool_ids]).each do |pool|
            pool.import_data
          end
        end
      end
    end
  end
end
