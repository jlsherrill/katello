module Actions
  module Katello
    class Foo < Actions::EntryAction
      include Dynflow::Action::WithSubPlans


      def plan(org)
        plan_self
      end

      def create_sub_plans
        trigger(::Actions::BulkAction,
                ::Actions::Katello::Bar,
                User.unscoped.all)
      end

    end
  end
end

