module Actions
  module Pulp
    module Repository
      class Refresh < Pulp::AbstractAsyncTask
        input_format do
          param :capsule_id
          param :pulp_id
        end

        def plan(repository, smart_proxy)
          plan_self(:capsule_id => smart_proxy.id, :pulp_id => repository.pulp_id)
        end

        def invoke_external_task
          repo = ::Katello::Repository.find_by(:pulp_id => input[:pulp_id])
          if repo.nil?
            repo = ::Katello::ContentViewPuppetEnvironment.find_by(:pulp_id => input[:pulp_id])
            repo = repo.nonpersisted_repository
          end
          repo.backend_service(smart_proxy(input[:capsule_id])).refresh
        end
      end
    end
  end
end
