class VirtualAlias < ActiveRecord::Migration
  def change
    create_table :virtual_aliases do |t|
      t.string :source
      t.string :destination
      t.references :virtual_domain
      t.timestamps
    end
  end
end
