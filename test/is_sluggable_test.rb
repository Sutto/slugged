require 'helper'
require 'digest/md5'

class IsSluggableTest < Test::Unit::TestCase
  with_tables :slugs, :users do
    
    class StringWrapper < String
      def to_url; "my-demo-slug"; end
    end
    
    context 'with the default slug options' do
      
      setup { setup_slugs! }
      
      should 'correctly sluggify a value' do
        user = User.create(:name => "Bob")
        assert_equal "bob", user.to_param
        assert_equal "bob", user.cached_slug
      end

      should 'generate a uuid in place of a slug' do
        user = User.create(:name => '')
        assert user.cached_slug.present?
      end

      should 'return need to generate a slug when the cahced slug is blank' do
        user = User.new(:name => "Ninja Stuff")
        assert user.cached_slug.blank?
        assert user.should_generate_slug?
        user.save
        assert user.cached_slug.present?
        assert !user.should_generate_slug?
        user.name = 'Awesome'
        assert user.should_generate_slug?
      end
      
      should "let you find a record by it's id as needed" do
        user = User.create :name => "Bob"
        assert_equal user, User.find_using_slug(user.id)
        assert_equal user, User.find_using_slug(user.id.to_i)
      end
      
      should 'return nil for unfound slugs by default' do
        assert_nil User.find_using_slug("awesome")
      end
      
      should 'let you find slugs and raise an exception' do
        assert_raises(ActiveRecord::RecordNotFound) do
          User.find_using_slug!("awesome")
        end
      end

      should 'default to generate a uuid' do
        user = User.create :name => ""
        assert_match /\A[a-zA-Z0-9]{32}\Z/, user.cached_slug.gsub("-", "")
        user = User.create
        assert_match /\A[a-zA-Z0-9]{32}\Z/, user.cached_slug.gsub("-", "")
      end

      should 'automatically append a sequence to the end of conflicting slugs' do
        u1 = User.create :name => "ninjas Are awesome"
        u2 = User.create :name => "Ninjas are awesome"
        assert_equal "ninjas-are-awesome",    u1.to_slug
        assert_equal "ninjas-are-awesome--1", u2.to_slug
      end

      should 'let you find out if there is a better way of finding a slug' do
        user = User.create :name => "Bob"
        user.update_attributes! :name => "Ralph"
        assert !User.find_using_slug("ralph").has_better_slug?
        assert User.find_using_slug("bob").has_better_slug?
        assert User.find_using_slug(user.id).has_better_slug?
      end
      
    end
    
    context 'with slug syncing disabled' do
      setup { setup_slugs! :sync => false }
      
      should 'let you disable syncing a slug' do
        user = User.create(:name => "Ninja User")
        assert !user.should_generate_slug?
        user.name = "Another User Name"
        assert !user.should_generate_slug?
      end
      
      should 'let you force slug generation' do
        user = User.create(:name => "Ninja User")
        assert_equal "ninja-user", user.to_slug
        user.update_attributes :name => "Test User"
        assert_equal "ninja-user", user.to_slug
        user.generate_slug!
        assert_equal "test-user", user.to_slug
        user.reload
        assert_equal "test-user", user.to_slug
      end
      
      should 'let you force the update of all slugs' do
        user_a = User.create(:name => "User A")
        user_b = User.create(:name => "User B")
        user_c = User.create(:name => "User C")
        user_a.update_attributes :name => "User A-1"
        user_b.update_attributes :name => "User B-1"
        user_c.update_attributes :name => "User C-1"
        assert_equal "user-a", user_a.to_slug
        assert_equal "user-b", user_b.to_slug
        assert_equal "user-c", user_c.to_slug
        User.update_all_slugs!
        user_a.reload
        user_b.reload
        user_c.reload
        assert_equal "user-a-1", user_a.to_slug
        assert_equal "user-b-1", user_b.to_slug
        assert_equal "user-c-1", user_c.to_slug
      end
      
    end
    
    context 'setting slug convertors' do
      
      should 'let you specify a symbol' do
        setup_slugs! :convertor => :upcase
        assert_equal "AWESOME USER", User.create(:name => "Awesome User").to_slug
      end
      
      should 'let you specify a proc' do
        setup_slugs! :convertor => proc { |r| r.reverse.upcase }
        assert_equal "RESU EMOSEWA", User.create(:name => "Awesome User").to_slug
      end
      
      should 'call to_url if available by default' do
        setup_slugs!
        original_value = StringWrapper.new("Awesome User")
        assert_equal "my-demo-slug", User.create(:name => original_value).to_slug
      end
      
    end
    
    should 'set the cached slug to nil if uuid is nil and the source value is blank' do
      setup_slugs! :uuid => nil
      record = User.create(:name => "")
      assert_nil record.cached_slug
      assert_equal record.id.to_s, record.to_slug
    end
    
  end
end