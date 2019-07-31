module Actions
  module Katello
    class Bar < Actions::EntryAction

      def plan(user)
        plan_self
      end


      def run
      end

    end
  end
end

