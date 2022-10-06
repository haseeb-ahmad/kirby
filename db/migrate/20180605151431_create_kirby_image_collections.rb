class CreateKirbyImageCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :kirby_image_collections do |t|
      t.timestamps
    end

    create_table :kirby_image_collections_images do |t|
      t.references :image_collection, index: true, foreign_key: { to_table: :kirby_image_collections }
      t.references :image, index: true, foreign_key: { to_table: :kirby_images }
      t.integer :position
    end
  end
end
