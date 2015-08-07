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
                   header_proc: Proc.new {})

      @options        = options
      @title          = title
      @default_color  = default_color
      @selected_color = selected_color
      @header_proc    = header_proc
      @stdin          = STDIN
      @stdout         = $stdout
    end

    def prompt(position = 0)
      @selected_position = position_selector(position)
      system("clear")
      header_proc.call
      print_title
      print_options
      stdout.print "\n> "
      process_input read_char
    end

    private

    attr_reader :options,
                :title,
                :selected_position,
                :header_proc,
                :selected_color,
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
        options.fetch(option_keys[selected_position])
      end
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
      when Array
        options.each_with_index do |option, index|
          stdout.puts colorize_option(option, index)
        end
      when Hash
        options.each_with_index do |option_array, index|
          if index == selected_position
            stdout.puts "(#{option_array.first}) #{option_array.last}"
          else
            stdout.print "(#{eval("option_array.first.#{default_color}")}) "
            stdout.print "#{eval("option_array.last.#{default_color}")}\n"
          end
        end
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
