class VirtualDomain < ActiveRecord::Migration
  def change
    create_table :virtual_domains do |t|
      t.string :name
      t.timestamps
    end
  end
end
