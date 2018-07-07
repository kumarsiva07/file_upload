class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :file_name
      t.string :content_type
      t.integer :file_size
      t.references :user,  foreign_key: true

      t.timestamps
    end
  end
end
