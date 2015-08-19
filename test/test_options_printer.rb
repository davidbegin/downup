require_relative 'minitest_helper'
require_relative 'fake_io'

class TestOptionsPrinter < Minitest::Test
  def setup
    @stdout = FakeStdout.new
    @options = ["Cat", "Kangaroo", "Dog"]
    @position = 0
    @subject = Downup::OptionsPrinter.new(
      options: @options,
      selected_position: @position,
      stdout: @stdout
    )
  end

  def test_options_printer_with_flair
    @subject.print_options
    assert @stdout.output.first.include? "Cat"
    assert @stdout.output.last.include? "Dog"
  end

  def test_options_printer_with_a_hash
    options = {
      "a" => "Dog",
      "b" => "Cat"
    }
    subject = Downup::OptionsPrinter.new(
      options: options,
      selected_position: @position,
      stdout: @stdout,
    )
    subject.print_options
    assert @stdout.output[0].include? "‣"
    assert @stdout.output[0].include? "Dog"
    assert @stdout.output[1].include? "b"
    assert @stdout.output[2].include? "Cat"
  end

  def test_options_printer_with_a_selector
    options = {
      "a" => "Dog",
      "b" => "Cat"
    }
    subject = Downup::OptionsPrinter.new(
      options: options,
      selected_position: 1,
      stdout: @stdout,
      selector: "***"
    )
    subject.print_options
    assert @stdout.output[0].include? "a"
    assert @stdout.output[1].include? "Dog"
    assert @stdout.output[2].include? "***"
    assert @stdout.output[2].include? "Cat"
  end
end
