module Actions
  module Pulp
    module Repository
      class Download < Pulp::AbstractAsyncTask
        include Helpers::Presenter

        input_format do
          param :pulp_id
          param :task_id # In case we need just pair this action with existing sync task
        end

        def invoke_external_task
          if input[:task_id]
            # don't initiate, just load the existing task
            task_resource.poll(input[:task_id])
          end
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

        def run_progress_weight
          10
        end

        def presenter
          Presenters::DownloadPresenter.new(self)
        end
      end
    end
  end
end
