require 'reversible_data'

ReversibleData.in_memory!

# Define models here.

ReversibleData.add :slugs do |t|
  t.string  :scope
  t.string  :slug
  t.integer :record_id
  t.datetime :created_at
end

ReversibleData.add :users do |u|
  u.string :name
  u.string :address
  u.string :cached_slug
  u.timestamps
end