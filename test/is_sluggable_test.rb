require 'helper'
require 'digest/md5'

class IsSluggableTest < Test::Unit::TestCase
  with_tables :users, :unslugged_users do
    
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
    
    should 'let you disable syncing a slug' do
      UnsluggedUser.is_sluggable :name, :sync => false
      user = UnsluggedUser.create(:name => "Ninja User")
      assert !user.should_generate_slug?
      user.name = "Another User Name"
      assert !user.should_generate_slug?
    end
    
    should 'by default record slug history' do
      user = User.create :name => "Bob"
      assert_equal [], user.previous_slugs
      user.update_attributes! :name => "Sal"
      user.update_attributes! :name => "Red"
      user.update_attributes! :name => "Jim"
      assert_equal ["red", "sal", "bob"], user.previous_slugs
      assert_equal user, User.find_using_slug("red")
      assert_equal user, User.find_using_slug("sal")
      assert_equal user, User.find_using_slug("bob")
      assert_equal user, User.find_using_slug("jim")
    end
    
    should 'let you disable recording of slug history' do
      UnsluggedUser.is_sluggable :name, :history => false
      user = UnsluggedUser.create(:name => "Bob")
      assert !user.respond_to?(:previous_slugs)
      user.update_attributes! :name => "Red"
      assert_equal user,     UnsluggedUser.find_using_slug("red")
      assert_not_equal user, UnsluggedUser.find_using_slug("bob")
      assert UnsluggedUser.find_using_slug("bob").blank?
    end
    
    should "let you find a record by it's id as needed" do
      user = User.create :name => "Bob"
      assert_equal user, User.find_using_slug(user.id)
      assert_equal user, User.find_using_slug(user.id.to_i)
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
      assert_equal "ninjas-are-awesome", u1.to_slug
      assert_equal "ninjas-are-awesome--1", u2.to_slug
    end
    
  end
end