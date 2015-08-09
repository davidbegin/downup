require "downup/version"
require "downup/colors"
require "io/console"

module Downup
  using Colors

  class Base
    def initialize(options:,
                   title: nil,
                   default_color: :brown,
                   selected_color: :magenta,
                   selector: "‣",
                   stdin: STDIN,
                   stdout: $stdout,
                   header_proc: Proc.new {})

      @options        = options
      @title          = title
      @default_color  = default_color
      @selected_color = selected_color
      @selector       = selector
      @header_proc    = header_proc
      @stdin          = stdin
      @stdout         = stdout
    end

    def prompt(position = 0)
      @selected_position = position_selector(position)
      system("clear")
      header_proc.call
      print_title
      print_options
      stdout.print "\n> "
      input = read_char
      process_input input
    end

    private

    attr_reader :options,
                :title,
                :selected_position,
                :header_proc,
                :selected_color,
                :selector,
                :default_color,
                :stdin,
                :stdout

    def process_input(input)
      case input
      when "\e[A", "k"
        prompt(selected_position - 1)
      when "\e[B", "j"
        prompt(selected_position + 1)
      when *option_keys
        prompt(option_keys.index(input))
      when "\r"
        execute_selection(input)
      when "\u0003" then exit
      else prompt(selected_position); end
    end

    def execute_selection(input)
      case options
      when Array
        options[selected_position]
      when Hash
        if options_has_value_and_display?
          options.fetch(option_keys[selected_position]).fetch("value")
        else
          options.fetch(option_keys[selected_position])
        end
      end
    end

    def options_has_value_and_display?
      options.values.all? { |option|
        option.is_a?(Hash) && option.has_key?("value")
      } && options.values.all? { |option|
        option.is_a?(Hash) && option.has_key?("display")
      }
    end

    def option_keys
      options.is_a?(Array) ? [] : options.keys
    end

    def position_selector(position)
      case position
      when -1 then options.count - 1
      when options.count then 0
      else position; end
    end

    def print_options
      case options
      when Array then print_array_options
      when Hash
        if options_has_value_and_display?
          print_complex_hash_options
        else
          print_simple_hash_options
        end
      end
    end

    def print_complex_hash_options
      options.each_with_index do |option_array, index|
        key = option_array.first
        value_hash = option_array.last
        if index == selected_position
          stdout.puts "(#{eval("selector.#{selected_color}")}) " +
            eval("value_hash.fetch('display').#{selected_color}")
        else
          stdout.print "(#{eval("key.#{default_color}")}) "
          stdout.print "#{eval("value_hash.fetch('display').#{default_color}")}\n"
        end
      end
    end

    def print_simple_hash_options
      options.each_with_index do |option_array, index|
        if index == selected_position
          stdout.puts "(#{eval("selector.#{selected_color}")}) " +
            eval("option_array.last.#{selected_color}")
        else
          stdout.print "(#{eval("option_array.first.#{default_color}")}) "
          stdout.print "#{eval("option_array.last.#{default_color}")}\n"
        end
      end
    end

    def print_array_options
      options.each_with_index do |option, index|
        stdout.puts colorize_option(option, index)
      end
    end

    def colorize_option(option, index)
      if index == selected_position
        eval("option.#{selected_color}")
      else
        eval("option.#{default_color}")
      end
    end

    def print_title
      return if title.nil?
      stdout.puts "#{title}".red
    end

    def read_char
      stdin.echo = false
      stdin.raw!
      input = stdin.getc.chr
      if input == "\e" then
        input << stdin.read_nonblock(3) rescue nil
        input << stdin.read_nonblock(2) rescue nil
      end
    ensure
      stdin.echo = true
      stdin.cooked!
      return input
    end
  end
end
