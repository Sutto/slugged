require 'helper'

class FakedModel
  attr_reader :id
  def self.slug_scope; "faked_models"; end
  def initialize(id); @id = id; end
end

class SlugHistoryTest < Test::Unit::TestCase
  
  context 'recording / checking slug history' do
    
    setup do
      @record_a = FakedModel.new(12)
      @record_b = FakedModel.new(4)
      Pseudocephalopod.record_slug(@record_a, "awesome")
      Pseudocephalopod.record_slug(@record_b, "awesome-1")
      Pseudocephalopod.record_slug(@record_a, "ninjas")
    end
    
    should 'let you lookup a given record id easily' do
      assert Pseudocephalopod.last_known_slug_id(FakedModel.slug_scope, "felafel").blank?
      assert Pseudocephalopod.last_known_slug_id(FakedModel.slug_scope, "ninjas-2").blank?
      assert_equal 12, Pseudocephalopod.last_known_slug_id(FakedModel.slug_scope, "awesome")
      assert_equal 4,  Pseudocephalopod.last_known_slug_id(FakedModel.slug_scope, "awesome-1")
      assert_equal 12, Pseudocephalopod.last_known_slug_id(FakedModel.slug_scope, "ninjas")
    end
    
  end
  
end