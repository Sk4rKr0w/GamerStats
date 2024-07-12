class RecreateTables2 < ActiveRecord::Migration[6.1]
  def change
    create_table "champions", force: :cascade do |t|
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "contacts", force: :cascade do |t|
      t.string "name"
      t.string "email"
      t.string "subject"
      t.text "message"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "status"
    end

    create_table "patch_notes", force: :cascade do |t|
      t.string "title"
      t.text "description"
      t.string "game"
      t.string "image_path"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "link_path"
    end

    create_table "players", force: :cascade do |t|
      t.string "riot_id"
      t.string "game_tag"
      t.string "puuid"
      t.integer "squad_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.float "win_rate"
      t.float "kills"
      t.float "deaths"
      t.float "assists"
      t.index ["squad_id"], name: "index_players_on_squad_id"
    end

    create_table "squads", force: :cascade do |t|
      t.string "name"
      t.integer "user_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "saved", default: false, null: false
      t.string "description"
      t.string "creator_name"
      t.index ["user_id"], name: "index_squads_on_user_id"
    end

    create_table "tickets", force: :cascade do |t|
      t.integer "user_id", null: false
      t.string "subject"
      t.text "message"
      t.string "status", default: "open"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id"], name: "index_tickets_on_user_id"
    end

    create_table "users", force: :cascade do |t|
      t.string "email", default: "", null: false
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.string "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string "unconfirmed_email"
      t.string "riot_id"
      t.string "two_factor_code"
      t.datetime "two_factor_expires_at"
      t.string "provider"
      t.string "uid"
      t.boolean "admin", default: false
      t.boolean "online"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "last_sign_in_at"
      t.boolean "banned", default: false
      t.datetime "banned_until"
      t.string "riot_tagline"
      t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    end

    add_foreign_key "players", "squads"
    add_foreign_key "squads", "users"
    add_foreign_key "tickets", "users"
  end
end
