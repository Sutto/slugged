require 'helper'

class PseudocephalopodTest < Test::Unit::TestCase
  
  should 'return the correct counter versions' do
    assert_equal 'awesome',      Pseudocephalopod.with_counter('awesome')
    assert_equal 'awesome',      Pseudocephalopod.with_counter('awesome', 0)
    assert_equal 'awesome',      Pseudocephalopod.with_counter('awesome', -1)
    assert_equal 'awesome--2',   Pseudocephalopod.with_counter('awesome', 2)
    assert_equal 'awesome--100', Pseudocephalopod.with_counter('awesome', 100)
  end
  
end
