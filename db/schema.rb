# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130315081006) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "hypertitle"
    t.text     "html",               :limit => 16777215
    t.string   "author"
    t.boolean  "published"
    t.integer  "category_id"
    t.integer  "issue_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "articles", ["category_id", "date"], :name => "index_articles_on_category_id_and_date"
  add_index "articles", ["created_at"], :name => "index_articles_on_created_at"
  add_index "articles", ["date"], :name => "index_articles_on_date"
  add_index "articles", ["issue_id", "category_id", "published"], :name => "index_articles_on_issue_id_and_category_id_and_published"

  create_table "banners", :force => true do |t|
    t.string   "describe"
    t.integer  "block_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "position"
  end

  add_index "banners", ["block_id", "position"], :name => "index_banners_on_block_id_and_position"

  create_table "blocks", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "mode"
    t.string   "placement"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "partial"
  end

  add_index "blocks", ["placement", "position"], :name => "index_blocks_on_placement_and_position"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "issued"
    t.integer  "order_articles"
    t.string   "mode"
  end

  add_index "categories", ["permalink", "id"], :name => "index_categories_on_permalink", :unique => true

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
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
    t.integer  "number"
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

  add_index "issues", ["number", "id"], :name => "index_issues_on_number_and_id", :unique => true

  create_table "navigators", :force => true do |t|
    t.string   "name"
    t.integer  "block_id"
    t.integer  "position"
    t.integer  "navigatable_id"
    t.string   "navigatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "navigators", ["block_id", "position"], :name => "index_navigators_on_block_id_and_position"
  add_index "navigators", ["navigatable_type", "navigatable_id"], :name => "index_navigators_on_navigatable_type_and_navigatable_id"

  create_table "orderings", :force => true do |t|
    t.integer  "article_id"
    t.integer  "issue_pos"
    t.integer  "cat_pos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orderings", ["article_id", "cat_pos"], :name => "index_orderings_on_article_id_and_cat_pos"
  add_index "orderings", ["article_id", "issue_pos"], :name => "index_orderings_on_article_id_and_issue_pos"

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

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink", :unique => true

  create_table "settings", :force => true do |t|
    t.string   "meta_key"
    t.string   "meta_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "article_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["article_id", "tag_id"], :name => "index_taggings_on_article_id_and_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
