class CreateKirbyLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :kirby_links do |t|
      t.belongs_to :page, index: true, null: false, foreign_key: { to_table: :kirby_pages }
      t.string :title
      t.timestamps
    end
  end
end
