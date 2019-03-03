class AddZombieIdToArmors < ActiveRecord::Migration[5.1]
  def change
    add_column :armors, :zombie_id, :integer
    add_index :armors, :zombie_id
  end
end
