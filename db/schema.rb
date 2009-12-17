# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 21) do

  create_table "articles", :force => true do |t|
    t.string   "subject"
    t.text     "rawtext"
    t.string   "message_id",     :default => "", :null => false
    t.integer  "parent_id",      :default => 0,  :null => false
    t.string   "reference"
    t.datetime "date"
    t.integer  "editor_id"
    t.string   "type",           :default => "", :null => false
    t.integer  "root_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "docid"
    t.integer  "root_editor_id", :default => 0
    t.integer  "reviews",        :default => 0
  end

  add_index "articles", ["message_id"], :name => "index_articles_on_message_id"
  add_index "articles", ["parent_id"], :name => "article_id_fkey"

  create_table "editors", :force => true do |t|
    t.string  "name"
    t.string  "full_name"
    t.integer "docs_posted"
    t.integer "docs_reviewed"
    t.boolean "is_ex"
  end

end
