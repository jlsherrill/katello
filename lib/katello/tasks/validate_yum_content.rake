namespace :katello do
  task :validate_yum_content => ["environment", "disable_dynflow", "katello:check_ping"] do
    User.as_anonymous_admin do
      Organization.all.each do |org|
        repos = Katello::Repository.in_organization(org).where(:library_instance_id => nil).yum_type.has_url
        repos = repos.where.not(:download_policy => ::Runcible::Models::YumImporter::DOWNLOAD_ON_DEMAND)
        if repos.any?
          task = ForemanTasks.async_task(::Actions::BulkAction,
                            ::Actions::Katello::Repository::Sync,
                            repos,
                            nil,
                            :validate_contents => true)

          puts "Starting sync and validate for all Repositories in Organization #{org.name} using task #{task.id} "
        end
      end
    end
  end
end
