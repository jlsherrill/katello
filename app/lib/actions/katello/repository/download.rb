module Actions
  module Katello
    module Repository
      class Download < Actions::EntryAction
        include Helpers::Presenter
        middleware.use Actions::Middleware::KeepCurrentUser


        # @param repo
        # @param pulp_sync_task_id in case the sync was triggered outside
        #   of Katello and we just need to finish the rest of the orchestration
        def plan(repo, pulp_sync_task_id)
          action_subject(repo)
          plan_action(Pulp::Repository::Download, :pulp_id => repo.pulp_id, :task_id => pulp_sync_task_id)
        end

        def humanized_name
          _("Download Repository")
        end

        def rescue_strategy
          Dynflow::Action::Rescue::Skip
        end

        def presenter
          Helpers::Presenter::Delegated.new(self, planned_actions(Pulp::Repository::Download))
        end

        def resource_locks
          :link
        end
      end
    end
  end
end
