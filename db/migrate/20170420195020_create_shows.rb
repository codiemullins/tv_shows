class CreateShows < ActiveRecord::Migration[5.0]
  def change
    create_table :shows do |t|
      t.string :name
      t.string :url
      t.string :show_type
      t.string :status
      t.integer :runtime
      t.date :premiered

      t.timestamps
    end
  end
end
