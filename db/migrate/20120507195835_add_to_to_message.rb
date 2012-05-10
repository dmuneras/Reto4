class AddToToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :to, :integer
  end
end
