require 'helper'

class PseudocephalopodTest < Test::Unit::TestCase
  
  class SlugScopeTest
    cattr_accessor :slug_scope_key
    self.slug_scope_key = "my-test-scope"
  end
  
  should 'return the correct counter versions' do
    assert_equal 'awesome',      Pseudocephalopod.with_counter('awesome')
    assert_equal 'awesome',      Pseudocephalopod.with_counter('awesome', 0)
    assert_equal 'awesome',      Pseudocephalopod.with_counter('awesome', -1)
    assert_equal 'awesome--2',   Pseudocephalopod.with_counter('awesome', 2)
    assert_equal 'awesome--100', Pseudocephalopod.with_counter('awesome', 100)
  end

  should 'correct allow you to slug scope keys' do
    assert_equal "my-test-scope", Pseudocephalopod.key_for_scope(SlugScopeTest)
    assert_equal "my-test-scope", Pseudocephalopod.key_for_scope(SlugScopeTest.new)
    assert_equal "my-test-scope", Pseudocephalopod.key_for_scope("my-test-scope")
    assert_equal "",              Pseudocephalopod.key_for_scope(nil)
    assert_equal "1",             Pseudocephalopod.key_for_scope(1)
    assert_equal "awesome",       Pseudocephalopod.key_for_scope(:awesome)
  end

end
