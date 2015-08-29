require_relative "downup/version"
require_relative "downup/options_printer"
require_relative "downup/colors"
require "io/console"

module Downup
  using Colors

  class Base
    attr_reader :selected_position

    def initialize(options:,
                   flash_message: nil,
                   flash_color: :green,
                   default_color: :brown,
                   selected_color: :magenta,
                   selector: "‣",
                   type: :default,
                   stdin: $stdin,
                   stdout: $stdout,
                   header_proc: Proc.new {})

      @options        = options
      @flash_color    = flash_color
      @flash_message  = flash_message
      @default_color  = default_color
      @selected_color = selected_color
      @selector       = selector
      @type           = type
      @header_proc    = header_proc
      @stdin          = stdin
      @stdout         = stdout
      @colonel        = Kernel

      @multi_selected_positions = []
    end

    def prompt(position = 0)
      @selected_position = position_selector(position)
      colonel.system("clear")
      header_proc.call
      print_flash
      Downup::OptionsPrinter.new(
        options: options,
        selected_position: @selected_position,
        multi_selected_positions: @multi_selected_positions,
        default_color: default_color,
        selected_color: selected_color,
        selector: selector,
        stdin: stdin,
        stdout: stdout,
      ).print_options
      stdout.print "\n> "
      input = read_char
      process_input input
    end

    private

    def options
      @_options ||=
        begin
          if multi_select?
            @options.merge({"z" => "ENTER"})
          else
            @options
          end
        end
    end

    attr_reader :flash_message,
                :flash_color,
                :header_proc,
                :selected_color,
                :selector,
                :type,
                :default_color,
                :stdin,
                :stdout,
                :colonel

    def process_input(input)
      case input
      when "\e[A", "k"
        prompt(selected_position - 1)
      when "\e[B", "j"
        prompt(selected_position + 1)
      when *option_keys
        prompt(option_keys.index(input))
      when "\r"
        if multi_select?
          manage_multi_select
          if selected_value == "ENTER"
            execute_selection(input)
          else
            prompt(selected_position)
          end
        else
          execute_selection(input)
        end
      when "\u0003" then exit
      else prompt(selected_position); end
    end

    def selected_value
      options.values[selected_position]
    end

    def manage_multi_select
      if @multi_selected_positions.include?(selected_position)
        @multi_selected_positions.delete(selected_position)
      else
        return if selected_position == @options.length
        @multi_selected_positions << selected_position
      end
    end

    def multi_select?
      type == :multi_select
    end

    def execute_selection(input)
      case options
      when Array
        options[selected_position]
      when Hash
        if options_has_value_and_display?
          options.fetch(option_keys[selected_position]).fetch("value")
        else
          if multi_select?
            @multi_selected_positions.map do |p|
              options.fetch(option_keys[p]) 
            end
          else
            options.fetch(option_keys[selected_position])
          end
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

    def print_flash
      return if flash_message.nil?
      colored_flash = "\"#{flash_message}\".#{flash_color}"
      stdout.puts eval(colored_flash)
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
