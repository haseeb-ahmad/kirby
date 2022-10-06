class CreateKirbyTables < ActiveRecord::Migration[5.2]
  def change
    create_table :kirby_accounts do |t|
      t.string   :name
      t.string   :suite
      t.string   :address
      t.string   :postal_code
      t.string   :city
      t.string   :province
      t.string   :phone
      t.string   :email
      t.text     :preferences
      t.string   :logo
      t.string   :kvk_identifier
      t.string   :vat_identifier
      t.boolean  :robots_allowed, default: false

      t.timestamps
    end

    create_table :kirby_attachment_collections, &:timestamps
    create_table :kirby_attachments do |t|
      t.string   :file
      t.timestamps
    end
    create_table :kirby_attachment_collections_attachments do |t|
      t.references :attachment_collection, index: { name: 'idx_kirby_atch_collections_atchs_on_atch_collection_id' }, foreign_key: { to_table: :kirby_attachment_collections }
      t.references :attachment, index: true, foreign_key: { to_table: :kirby_attachments }
    end

    create_table :kirby_layout_parts do |t|
      t.string   :title
      t.string   :name
      t.references :layout_partable, polymorphic: true, index: { name: 'idx_kirby_lyt_parts_on_lyt_prtable_type_and_lyt_prtable_id' }
      t.references :account, index: true, foreign_key: { to_table: :kirby_accounts }

      t.timestamps
    end

    create_table :kirby_pages do |t|
      t.boolean  :show_in_menu, default: true
      t.string   :slug
      t.boolean  :deletable, default: true
      t.string   :name
      t.boolean  :skip_to_first_child, default: false
      t.string   :view_template
      t.string   :layout_template
      t.boolean  :draft, default: false
      t.string   :link_url
      t.string   :ancestry
      t.integer  :position
      t.boolean  :active, default: true

      t.timestamps
    end
    create_table :kirby_page_translations do |t|
      t.belongs_to :kirby_page, null: false, index: true, foreign_key: { to_table: :kirby_pages }
      t.string :locale, null: false
      t.string :title
      t.string :menu_title
      t.string :description
      t.string :seo_title
      t.string :materialized_path

      t.timestamps

      t.index [:locale], name: 'index_kirby_page_translations_on_locale'
    end
    create_table :kirby_page_parts do |t|
      t.string   :title
      t.string   :name
      t.references :page, index: true, foreign_key: { to_table: :kirby_pages }
      t.references :page_partable, polymorphic: true, index: { name: 'idx_kirby_pg_prts_on_pg_prtable_type_and_pg_prtable_id' }

      t.timestamps
    end

    create_table :kirby_structures, &:timestamps
    create_table :kirby_structure_items do |t|
      t.references :structure, index: true, foreign_key: { to_table: :kirby_structures }
      t.integer  :position

      t.timestamps
    end
    create_table :kirby_structure_parts do |t|
      t.references :structure_item, index: true, foreign_key: { to_table: :kirby_structure_items }
      t.references :structure_partable, polymorphic: true, index: { name: 'idx_kirby_strc_parts_on_strc_partable_type_and_strc_partable_id' }
      t.string   :name
      t.string   :title

      t.timestamps
    end

    create_table :kirby_texts, &:timestamps
    create_table :kirby_text_translations do |t|
      t.belongs_to :kirby_text, null: false, index: true, foreign_key: { to_table: :kirby_texts }
      t.string :locale, null: false, index: true
      t.text :content

      t.timestamps
    end

    create_table :kirby_lines, &:timestamps
    create_table :kirby_line_translations do |t|
      t.belongs_to :kirby_line, null: false, index: true, foreign_key: { to_table: :kirby_lines }
      t.string :locale, null: false, index: true
      t.string :content

      t.timestamps
    end

    create_table :kirby_options do |t|
      t.string :value
      t.timestamps
    end

    create_table :kirby_navigations do |t|
      t.string :name, null: false
      t.string :label, null: false
      t.boolean :auto_add_pages, null: false, default: false
      t.integer :position, default: 0, null: false

      t.timestamps

      t.index [:name], name: :index_kirby_navigations_on_name, unique: true, using: :btree
    end
    create_table :kirby_navigation_items do |t|
      t.references :page, null: false, foreign_key: { to_table: :kirby_pages }
      t.references :navigation, null: false, foreign_key: { to_table: :kirby_navigations }
      t.integer :position, default: 0, null: false
      t.string :ancestry

      t.timestamps

      t.index %i[page_id navigation_id], name: 'index_kirby_navigation_items_on_page_id_and_navigation_id', unique: true, using: :btree
    end

    create_table :kirby_users do |t|
      t.string   :name
      t.string   :email
      t.string   :password_digest
      t.boolean  :admin, default: false
      t.datetime :last_logged_in
      t.string :password_reset_token
      t.datetime :password_reset_sent_at

      t.timestamps
    end

    create_table :kirby_rewrite_rules do |t|
      t.string :old_path
      t.string :new_path

      t.timestamps
    end

    create_table :kirby_settings do |t|
      t.string :plugin
      t.jsonb :preferences, default: {}
      t.timestamps

      t.index [:plugin]
    end

    create_table :kirby_media_folders do |t|
      t.string :name
      t.timestamps
    end

  end
end
