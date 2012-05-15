class RenameColumnRoleMaskUser < ActiveRecord::Migration
  def up
    rename_column :users, :role_mask, :roles_mask
  end

  def down
    rename_column :users, :roles_mask, :role_mask
  end
end
