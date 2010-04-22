require 'reversible_data'

ReversibleData.in_memory!

# Define models here.

slugs = ReversibleData.add :slugs do |t|
  t.string  :scope
  t.string  :slug
  t.integer :record_id
  t.datetime :created_at
end

slugs.create_table

user = ReversibleData.add :users do |u|
  u.string :name
  u.string :cached_slug
  u.timestamps
end

user.define_model do
  is_sluggable :name
end

ReversibleData.add :unslugged_users do |u|
  u.string :name
  u.string :cached_slug
  u.timestamps
end