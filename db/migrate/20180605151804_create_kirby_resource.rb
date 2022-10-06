class CreateKirbyResource < ActiveRecord::Migration[5.2]
  def change
    create_table :kirby_resources do |t|
      t.string :name, null: false, unique: true
      t.string :label
      t.string :view_template
      t.integer :parent_page_id
      t.string :order_by
      t.timestamps
    end

    add_reference :kirby_pages, :resource, index: true, null: true, foreign_key: { to_table: :kirby_resources }
    add_index :kirby_resources, :parent_page_id
  end
end
