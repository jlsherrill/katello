module Actions
  module Pulp
    module Repository
      module Presenters
        class DownloadPresenter < AbstractSyncPresenter
          def progress
            items_total == 0 ? 0.01 : num_processed.to_f / items_total
          end

          private

          def humanized_details
            ret = []
#            ret << _("Cancelled.") if cancelled?
            ret << _("Downloaded Files: %{processed}/%{total}") % {:processed => num_processed, :total => items_total}
            ret.join("\n")
          end

          def num_processed
            task_progress && task_progress['num_processed'] || 0
          end

          def items_total
            task_progress && task_progress['items_total'] || 0
          end

          def task_progress
            sync_task['progress_report'].try(:[], 'background_download').try(:first)
          end

          def sync_task
            tasks = action.external_task.select do |task|
              if task.key? 'tags'
                task['tags'].include?("pulp:action:download")
              else
                task['result']
              end
            end
            tasks.first
          end
        end
      end
    end
  end
end
