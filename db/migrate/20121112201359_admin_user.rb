class AdminUser < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string :name
      t.timestamps
    end
  end
end
