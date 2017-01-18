class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.references :user, foreign_key: true
      t.references :wiki, foreign_key: true

      t.timestamps
    end
  end
end
