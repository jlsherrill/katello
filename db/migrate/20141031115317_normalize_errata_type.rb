class NormalizeErrataType < ActiveRecord::Migration
  class Erratum < ActiveRecord::Base
    set_table_name :katello_errata
    has_one :erratum_type, :class_name => "Katello::ErratumType"

  end

  def up
    create_table "katello_erratum_types" do |t|
      t.string :name
    end

    add_index :katello_erratum_types, [:name], :unique => true

    add_column :katello_errata, :erratum_type_id, :integer, :null => true

    Erratum.find_each do |e|
      e.update_column(:erratum_type_id, Katello::ErratumType.where(:name => e.errata_type).first_or_create!.id)
    end

    change_column :katello_errata, :erratum_type_id, :integer, :null => false

  end

  def down
    add_column :katello_errata, :errata_type, :string
    Erratum.find_each do |e|
      e.update_column(:errata_type, e.erratum_type.name)
    end

    remove_column :katello_errata, :erratum_type_id
    drop_table :katello_erratum_types

  end
end
