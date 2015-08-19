require_relative 'minitest_helper'
require_relative 'fake_io'

class TestDownup < Minitest::Test
  def setup
    @stdout = FakeStdout.new
    @subject = Downup::Base.new(
      options: ["Cat", "Rat", "Dog"],
      stdout: @stdout
    )
  end

  J     = "j"
  K     = "k"
  UP    = "\e[A"
  DOWN  = "\e[B"
  ENTER = "\r"

  def test_that_it_has_a_version_number
    refute_nil ::Downup::VERSION
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

  def test_you_can_use_the_arrow_keys_to_make_a_selection1
    input = [UP, ENTER]
    define_input_for_subject(input)

    result = @subject.prompt

    assert_equal result, "Dog"
    assert_equal @subject.selected_position, 2
  end

  def test_you_can_use_the_arrow_keys_to_make_a_selection2
    input = [UP, UP, ENTER]
    define_input_for_subject(input)

    result = @subject.prompt
    assert_equal result, "Rat"
    assert_equal @subject.selected_position, 1
  end

  def test_you_can_use_the_arrow_keys_to_make_a_selection3
    input = [DOWN, DOWN, ENTER]
    define_input_for_subject(input)

    result = @subject.prompt
    assert_equal result, "Dog"
    assert_equal @subject.selected_position, 2
  end

  def test_you_can_use_j_and_k
    input =  [K, J, J, ENTER]
    define_input_for_subject(input)
    result = @subject.prompt
    assert_equal result, "Rat"
    assert_equal @subject.selected_position, 1
  end

  private

  def define_input_for_subject(input)
    @subject.instance_exec(input) do |input|
      @input = input.reverse
      def read_char
        @input.pop
      end
    end
  end
end
