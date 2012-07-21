class OriginalDatabaseMigration < ActiveRecord::Migration
  def self.up
    create_table "articles", :force => true do |t|
      t.string   "title"
      t.string   "hypertitle"
      t.text     "html"
      t.string   "author"
      t.boolean  "published"
      t.integer  "category_id", :limit => 1
      t.integer  "issue_id", :limit => 3
      t.date     "date"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "photo_file_name"
      t.string   "photo_content_type"
      t.integer  "photo_file_size"
      t.datetime "photo_updated_at"
    end
    execute("ALTER TABLE `articles` CHANGE `id` `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :articles, "category_id"
    add_index :articles, "issue_id"
    add_index :articles, "date"
    add_index :articles, "created_at"

    create_table "banners", :force => true do |t|
      t.string   "describe"
      t.integer  "block_id", :limit => 1
      t.string   "photo_file_name"
      t.string   "photo_content_type"
      t.integer  "photo_file_size"
      t.datetime "photo_updated_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "url"
      t.integer  "position", :limit => 1
    end

    execute("ALTER TABLE `banners` CHANGE `id` `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :banners, ["block_id", "position"]

    create_table "blocks", :force => true do |t|
      t.integer  "position", :limit => 1
      t.string   "name"
      t.string   "mode"
      t.string   "placement"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "partial"
    end

    execute("ALTER TABLE `blocks` CHANGE `id` `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :blocks, [:placement, :position]

    create_table "categories", :force => true do |t|
      t.string   "name"
      t.string   "permalink"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "issued"
    end

    execute("ALTER TABLE `categories` CHANGE `id` `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :categories, :permalink, unique: true

    create_table "ckeditor_assets", :force => true do |t|
      t.string   "data_file_name",    :null => false
      t.string   "data_content_type"
      t.integer  "data_file_size"
      t.integer  "assetable_id"
      t.string   "assetable_type",    :limit => 30
      t.string   "type",              :limit => 30
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
    add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

    create_table "issues", :force => true do |t|
      t.integer  "number", :limit => 3
      t.date     "date"
      t.boolean  "published"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "cover_file_name"
      t.string   "cover_content_type"
      t.integer  "cover_file_size"
      t.datetime "cover_updated_at"
      t.string   "pdf_file_name"
      t.string   "pdf_content_type"
      t.integer  "pdf_file_size"
      t.datetime "pdf_updated_at"
    end

    execute("ALTER TABLE `issues` CHANGE `id` `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :issues, :number, unique: true

    create_table "navigators", :force => true do |t|
      t.string   "name"
      t.integer  "block_id", :limit => 1
      t.integer  "position", :limit => 1
      t.integer  "navigatable_id"
      t.string   "navigatable_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    execute("ALTER TABLE `navigators` CHANGE `id` `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :navigators, ["block_id", "position"]
    add_index :navigators, ["navigatable_type", "navigatable_id"]

    create_table "orderings", :force => true do |t|
      t.integer  "article_id", :limit => 3
      t.integer  "issue_pos"
      t.integer  "cat_pos"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    execute("ALTER TABLE `orderings` CHANGE `id` `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :orderings, ["article_id", "issue_pos"]
    add_index :orderings, ["article_id", "cat_pos"]


    create_table "pages", :force => true do |t|
      t.string   "name"
      t.string   "title"
      t.string   "meta_description"
      t.text     "content"
      t.string   "permalink"
      t.boolean  "published"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    execute("ALTER TABLE `pages` CHANGE `id` `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :pages, :permalink, unique: true

    create_table "settings", :force => true do |t|
      t.string   "meta_key"
      t.string   "meta_value"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    execute("ALTER TABLE `settings` CHANGE `id` `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT")

    create_table "taggings", :force => true do |t|
      t.integer  "article_id", :limit => 3
      t.integer  "tag_id", :limit => 3
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    execute("ALTER TABLE `taggings` CHANGE `id` `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index :taggings, ["article_id", "tag_id"]

    create_table "tags", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    execute("ALTER TABLE `tags` CHANGE `id` `id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT")

    create_table "users", :force => true do |t|
      t.string   "email",                                 :default => "", :null => false
      t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                         :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "roles_mask"
    end

    execute("ALTER TABLE `users` CHANGE `id` `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT")
    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  end

  def self.down
    drop_table :users
    drop_table :orderings
    drop_table :navigators
    drop_table :issues
    drop_table :current_issues
    drop_table :ckeditor_assets
    drop_table :categories
    drop_table :blocks
    drop_table :banners
    drop_table :articles
    drop_table :tags
    drop_table :taggings
    drop_table :pages
  end
end

