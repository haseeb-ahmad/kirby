class CreateKirbyImages < ActiveRecord::Migration[5.2]
  def change
    create_table :kirby_images do |t|
      t.integer :media_folder_id
      t.timestamps
    end
    add_index :kirby_images, :media_folder_id
  end
end
