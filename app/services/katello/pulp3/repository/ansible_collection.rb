require 'pulp_file_client'
require 'pulp_ansible_client'

module Katello
  module Pulp3
    class Repository
      class AnsibleCollection < ::Katello::Pulp3::Repository
        def api_client
          PulpAnsibleClient::ApiClient.new(smart_proxy.pulp3_configuration(PulpAnsibleClient::Configuration))
        end

        def remote_class
          PulpAnsibleClient::CollectionRemote
        end

        def remotes_api
          PulpAnsibleClient::RemotesCollectionApi.new(api_client)
        end

        def distribution_class
          PulpAnsibleClient::AnsibleDistribution
        end

        def distributions_api
          PulpAnsibleClient::DistributionsAnsibleApi.new(api_client)
        end

        def remote_options
          if root.url.blank?
            super
          else
            common_remote_options.merge(url: root.url, whitelist: root.ansible_collection_whitelist)
          end
        end

        def distribution_options(path)
          {
            base_path: path,
            repository_version: repo.version_href,
            name: "#{backend_object_name}"
          }
        end
      end
    end
  end
end
