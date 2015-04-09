class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.date :since, null: false
      t.string :periodicity, null: false, default: 'once'

      t.timestamps null: false
    end
  end
end
