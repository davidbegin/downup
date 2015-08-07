require "downup/version"
require "downup/colors"
require "io/console"

module Downup
  using Colors

  class Base
    def initialize(options)
      @options = options
    end

    def prompt(position = 0)
      @selected_position = position_selector(position)
      print_options
      print "\n> "
      process_input read_char
    end

    private

    attr_reader :options, :selected_position

    def process_input(input)
      case input
      when "\e[A"
        prompt(selected_position - 1)
      when "\e[B"
        prompt(selected_position + 1)
      when "\u0003" then exit
      when "\r"
        puts options[selected_position]
      else
        prompt(selected_position)
      end
    end

    def position_selector(position)
      case position
      when -1 then options.count - 1
      when options.count then 0
      else position; end
    end

    def print_options
      system("clear")
      options.each_with_index do |option, index|
        puts index == selected_position ? option.bg_magenta : option
      end
    end

    def read_char
      STDIN.echo = false
      STDIN.raw!
      input = STDIN.getc.chr
      if input == "\e" then
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end
    ensure
      STDIN.echo = true
      STDIN.cooked!
      return input
    end
  end
end
