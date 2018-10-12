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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_12_071150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "eth_to_ebcs", force: :cascade do |t|
    t.string "address"
    t.string "value"
    t.datetime "initialized_at"
    t.string "eth_tx_hash"
    t.integer "eth_block_num"
    t.datetime "eth_block_at"
    t.string "ac_tx_hash"
    t.datetime "ac_tx_at"
    t.integer "ac_block_height"
    t.integer "ac_block_at"
    t.integer "status", default: 0
    t.datetime "status_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_eth_to_ebcs_on_address"
    t.index ["status"], name: "index_eth_to_ebcs_on_status"
  end

end
