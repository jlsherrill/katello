module Actions
  module Katello
    module Repository
      class InitiateDownloadTask <  Actions::Base
        middleware.use Actions::Middleware::KeepCurrentUser

        input_format do
          param :repo_id, Integer
          param :tasks, Array
        end

        def finalize
          repo = ::Katello::Repository.find(input[:repo_id])
          if input[:tasks] && repo
            input[:tasks].each do |task|
              if task['tags'].include?('pulp:action:download')
                ForemanTasks.async_task(::Actions::Katello::Repository::Download, repo, task['task_id'])
              end
            end
          end
        end
      end
    end
  end
end
