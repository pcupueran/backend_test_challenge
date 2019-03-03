class AddZombieIdToWeapons < ActiveRecord::Migration[5.1]
  def change
    add_column :weapons, :zombie_id, :integer
    add_index :weapons, :zombie_id
  end
end
