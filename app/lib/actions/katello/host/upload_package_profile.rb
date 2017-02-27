module Actions
  module Katello
    module Host
      class UploadPackageProfile < Actions::EntryAction
        middleware.use Actions::Middleware::KeepCurrentUser

        def plan(host, profile_json)
          action_subject host

          plan_self(:host_id => host.id, :profile_json => profile_json, :hostname => host.name)
          plan_action(GenerateApplicability, [host])
        end

        def run
          host = ::Host.find(input[:host_id])
          profile = JSON.parse(input[:profile_json])

          ::Katello::Pulp::Consumer.new(host.content_facet.uuid).upload_package_profile(profile) if host.content_facet.uuid
          simple_packages = profile.map { |item| ::Katello::Pulp::SimplePackage.new(item) }
          host.import_package_profile(simple_packages)

          #free the huge string from the memory
          input[:profile_json] = 'TRIMMED'.freeze
        end

        def humanized_name
          if input.try(:[], :hostname)
            _("Package Profile Update for %s") % input[:hostname]
          else
            _('Package Profile Update')
          end
        end

        def resource_locks
          :link
        end

        def rescue_strategy
          Dynflow::Action::Rescue::Skip
        end
      end
    end
  end
end
