class AddPlanIdToUser < ActiveRecord::Migration
  def change
  add_column :users, :planid, :string
  add_column :users, :subscribed, :boolean, :default => false
  add_column :users, :stripeid, :string
  end
end
