require 'katello_test_helper'

module Katello
  class DockerManifestTest < ActiveSupport::TestCase
    REPO_ID = "Default_Organization-Test-redis".freeze
    MANIFESTS = File.join(Katello::Engine.root, "test", "fixtures", "pulp", "docker_manifests.yml")
    TAGS = File.join(Katello::Engine.root, "test", "fixtures", "pulp", "docker_tags.yml")

    def setup
      @manifests = YAML.load_file(MANIFESTS).values.map(&:deep_symbolize_keys)
      @tags = YAML.load_file(TAGS).values.map(&:deep_symbolize_keys)
      @repo = Repository.find(katello_repositories(:redis).id)

      ids = @manifests.map { |attrs| attrs[:_id] }

      #::Katello::Repository.any_instance.stubs(:pulp_docker_manifest_ids).returns(ids)
      #Runcible::Extensions::Repository.any_instance.stubs(:unit_search).returns(@tags)
      #Runcible::Extensions::DockerManifest.any_instance.stubs(:find_all_by_unit_ids).
      #with(ids).returns(@manifests)
      Katello::Pulp::DockerManifest.stubs(:ids_for_repository).returns(ids)
      Katello::Pulp::DockerManifest.stubs(:fetch).returns(@manifests)
    end

    def test_index_db_docker_manifests
      Katello::DockerManifest.import_for_repository(@repo)

      assert_equal 1, DockerManifest.count
      assert_equal 1, @repo.docker_manifests.count
      assert_equal ["manifest1"], DockerManifest.all.map(&:name).sort
      assert_equal "sha256:f52325afc9c353f58d65b24d8f9a5e61be83f0518aa222639cb77bc7b77d49a9", DockerManifest.all.first.digest
    end
  end
end
