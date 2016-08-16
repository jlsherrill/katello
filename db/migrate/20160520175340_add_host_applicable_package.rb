class AddHostApplicablePackage < ActiveRecord::Migration
  def change
    create_table "katello_content_facet_applicable_rpms" do |t|
      t.references 'content_facet', :null => false
      t.references 'rpm', :null => false
    end
  end
end
