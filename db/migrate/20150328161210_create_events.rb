class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.date :start, null: false
      t.string :periodicity, null: false, default: 'once'

      t.timestamps null: false
    end
  end
end
