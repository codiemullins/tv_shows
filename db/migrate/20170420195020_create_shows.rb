class CreateShows < ActiveRecord::Migration[5.0]
  def change
    create_table :shows do |t|
      t.string  :name
      t.string  :url
      t.string  :show_type
      t.string  :status
      t.integer :runtime
      t.date    :premiered
      t.integer :tvmaze_id
      t.string  :imdb_id
      t.string  :tvrage_id
      t.string  :thetvdb_id
      t.text    :summary
      t.integer :network_id
      t.string  :language

      t.timestamps
    end

    add_attachment :shows, :medium
    add_attachment :shows, :original
  end
end
