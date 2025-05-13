# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_05_11_205219) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agenda_laboratorista", force: :cascade do |t|
    t.integer "laboratorista_id"
    t.date "fecha"
    t.time "hora_inicio"
    t.time "hora_fin"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "codigo_muestra"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "compras", force: :cascade do |t|
    t.decimal "monto", precision: 10, scale: 2
    t.bigint "servicio_id", null: false
    t.bigint "cliente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_compras_on_cliente_id"
    t.index ["servicio_id"], name: "index_compras_on_servicio_id"
  end

  create_table "costos_servicio_por_tipo_clientes", force: :cascade do |t|
    t.bigint "tipo_cliente_id"
    t.bigint "servicio_id"
    t.decimal "costo", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["servicio_id"], name: "index_costos_servicio_por_tipo_clientes_on_servicio_id"
    t.index ["tipo_cliente_id"], name: "index_costos_servicio_por_tipo_clientes_on_tipo_cliente_id"
  end

  create_table "informes", force: :cascade do |t|
    t.string "codigo_solicitud"
    t.integer "laboratorista_id"
    t.integer "gerente_id"
    t.datetime "fecha_generacion"
    t.datetime "fecha_firma_gerente"
    t.datetime "fecha_envio_cliente"
    t.string "archivo"
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notificacions", force: :cascade do |t|
    t.integer "cliente_id"
    t.text "mensaje"
    t.datetime "fecha_envio"
    t.integer "informe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samples", force: :cascade do |t|
    t.string "code", null: false
    t.text "results", null: false
    t.bigint "user_id"
    t.bigint "laboratorista_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "servicio_id"
    t.date "fecha_recepcion"
    t.string "prioridad"
    t.text "observaciones"
    t.date "fecha_resultado"
    t.string "estado"
    t.integer "lock_version"
    t.string "apellidos_y_nombres"
    t.string "institucion"
    t.string "titulo_investigacion"
    t.string "email_contacto"
    t.string "telefono_contacto"
    t.string "condicion"
    t.string "nombre_muestra"
    t.string "numero_muestras"
    t.string "area_analisis"
    t.string "analisis_solicitado"
    t.string "monto_pago"
    t.string "recibo_caja"
    t.text "observacion"
    t.bigint "solicitud_id"
    t.index ["code"], name: "index_samples_on_code", unique: true
    t.index ["laboratorista_id"], name: "index_samples_on_laboratorista_id"
    t.index ["solicitud_id"], name: "index_samples_on_solicitud_id"
    t.index ["user_id"], name: "index_samples_on_user_id"
  end

  create_table "servicios", force: :cascade do |t|
    t.string "codigo_servicio"
    t.string "nombre"
    t.text "descripcion"
    t.float "costo_base"
    t.integer "laboratorista_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imagen"
  end

  create_table "solicituds", force: :cascade do |t|
    t.string "apellidos_y_nombres"
    t.string "institucion"
    t.string "titulo_investigacion"
    t.string "email"
    t.string "telefono"
    t.string "condicion"
    t.string "codigo"
    t.bigint "user_id", null: false
    t.string "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_solicituds_on_user_id"
  end

  create_table "tipo_clientes", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "role", default: 2, null: false
    t.integer "tipo_cliente_id"
    t.string "verification_code"
    t.boolean "verified", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "compras", "servicios"
  add_foreign_key "compras", "users", column: "cliente_id"
  add_foreign_key "costos_servicio_por_tipo_clientes", "servicios"
  add_foreign_key "costos_servicio_por_tipo_clientes", "tipo_clientes"
  add_foreign_key "samples", "solicituds"
  add_foreign_key "samples", "users", column: "laboratorista_id", on_delete: :cascade
  add_foreign_key "samples", "users", on_delete: :cascade
  add_foreign_key "solicituds", "users"
end
