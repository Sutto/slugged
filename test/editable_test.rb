require 'helper'
require 'digest/md5'

class EditableTest < Test::Unit::TestCase
  with_tables :slugs, :users do
    context 'with the editable option' do

      setup { setup_slugs! }

      should 'correctly sluggify a value when cached_slug is blank on create' do
        user = User.create(:name => "Bob")
        assert_equal "bob", user.cached_slug
      end

      should 'not sluggify a value when cached_slug is not blank on create' do
        user = User.create(:name => "Bob", :cached_slug => "Mob")
        assert_equal "mob", user.cached_slug
      end

      should 'sluggify a value when cached_slug is not changed && name is changed on update' do
        user = User.create(:name => "Bob")
        user.update_attributes(:name => "Noob")
        assert_equal "noob", user.cached_slug
      end

      should 'not sluggify a value when cached_slug is changed && name is changed on update' do
        user = User.create(:name => "Bob")
        user.update_attributes(:name => "Rob", :cached_slug => "noob")
        assert_equal "noob", user.cached_slug
      end

      should 'sluggify a value when cached_slug set blank on update' do
        user = User.create(:name => "Bob")
        assert_equal "bob", user.cached_slug
        user.update_attributes(:cached_slug => '')
        assert_equal "bob", user.cached_slug
      end

      should 'sluggify a value when cached_slug set blank && name changed on update' do
        user = User.create(:name => "Bob")
        user.update_attributes(:name => "Rob", :cached_slug => '')
        assert_equal "rob", user.cached_slug
      end

      should 'parameterize a value of a cached_slug' do
        user = User.create(:name => "Bob", :cached_slug => "f**ck")
        assert_equal user.cached_slug, User.slug_value_for("f**ck")
      end
    end
  end
end