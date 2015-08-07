# require 'minitest_helper'
require_relative 'minitest_helper'

class TestDownup < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Downup::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  def test_prompt_can_be_tested
    Downup::Base.new(options: ["Dog"]).prompt
  end
end
