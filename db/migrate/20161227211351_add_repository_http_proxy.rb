class AddRepositoryHttpProxy < ActiveRecord::Migration
  def change
    add_column :katello_repositories, :http_proxy_id, :integer
  end
end
