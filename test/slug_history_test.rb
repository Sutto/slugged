require 'helper'

class FakedModel
  attr_reader :id
  def self.slug_scope_key; "faked_models"; end
  def initialize(id); @id = id; end
end

class SlugHistoryTest < Test::Unit::TestCase
  with_tables :slugs, :users do
    
    context 'for arbitrary models' do
    
      setup do
        @record_a = FakedModel.new(12)
        @record_b = FakedModel.new(4)
        Pseudocephalopod.record_slug(@record_a, "awesome")
        Pseudocephalopod.record_slug(@record_b, "awesome-1")
        Pseudocephalopod.record_slug(@record_a, "ninjas")
      end
    
      should 'let you lookup a given record id easily' do
        assert Pseudocephalopod.last_known_slug_id(FakedModel, "felafel").blank?
        assert Pseudocephalopod.last_known_slug_id(FakedModel, "ninjas-2").blank?
        assert_equal 12, Pseudocephalopod.last_known_slug_id(FakedModel, "awesome")
        assert_equal 4,  Pseudocephalopod.last_known_slug_id(FakedModel, "awesome-1")
        assert_equal 12, Pseudocephalopod.last_known_slug_id(FakedModel, "ninjas")
      end
      
      should 'let you return slug history for a given record'
    
    end
    
    context 'on a specific record' do
      
      should 'by default record slug history' do
        setup_slugs!
        user = User.create :name => "Bob"
        assert_equal [], user.previous_slugs
        user.update_attributes! :name => "Sal"
        user.update_attributes! :name => "Red"
        user.update_attributes! :name => "Jim"
        assert_equal ["red", "sal", "bob"], user.previous_slugs
        assert_same_as_slug user, "red"
        assert_same_as_slug user, "sal"
        assert_same_as_slug user, "bob"
        assert_same_as_slug user, "jim"  
      end

      should 'let you disable recording of slug history' do
        setup_slugs! :history => false
        user = User.create(:name => "Bob")
        assert !user.respond_to?(:previous_slugs)
        user.update_attributes! :name => "Red"
        assert_same_as_slug      user, "red"
        assert_different_to_slug user, "bob"
        assert_none_for_slug "bob"
      end
      
    end
    
  end
  
end