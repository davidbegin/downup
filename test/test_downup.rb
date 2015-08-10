# require 'minitest_helper'
require_relative 'minitest_helper'

class TestDownup < Minitest::Test
  def setup
    @subject = Downup::Base.new(options: ["Dog", "Cat", "Snake"])
  end

  def test_that_it_has_a_version_number
    refute_nil ::Downup::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_position_selector_wraps_around
    assert_equal @subject.send(:position_selector, 3), 0
  end

  def test_position_selector_reverse_wraps_around
    assert_equal @subject.send(:position_selector, -1), 2
  end

  def test_position_selector_does_nothing_if_in_the_middle
    assert_equal @subject.send(:position_selector, 1), 1
  end

  def test_prompt_can_be_tested
    Downup::Base.new(options: ["Dog"]).prompt
  end
end
