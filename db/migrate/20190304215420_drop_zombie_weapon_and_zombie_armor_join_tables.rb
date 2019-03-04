class DropZombieWeaponAndZombieArmorJoinTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :zombie_armors
    drop_table :zombie_weapons
  end
end
