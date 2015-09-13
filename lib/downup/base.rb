require_relative "version"
require_relative "options_printer"
require_relative "colors"
require "io/console"

module Downup
  using Colors

  ##
  # The main interface to use Downup
  #
  # initialize a Downup::Base object with all your desired options
  # and call +#prompt+ to retrieve the user selection.
  class Base
    attr_reader :selected_position

    # @param options [Hash|Array] collection of options to choose from
    # @param flash_message [String] A message to be displayed above the downup menu
    # @param flash_color [Symbol] color of flash message
    # @param default_color [Symbol] The color an unchoosen item
    # @param selected_color [Symbol] The color a choosen item
    # @param multi_select_selector [String] The charactor for selected items in multi mode
    # @param selector [String] The charactor for the moving selector in non-multi mode
    # @param type [Symbol] single select/default or multi select mode, `:default` or `:multi_select`
    # @param header_proc [Proc] a proc that will called before each render of option selection
    #
    # @example array of options
    #   Downup::Base.new(options: ["option 1", "option 2"])
    #
    # @example hash of options
    #   Downup::Base.new(options: {"a" => "option 1", "b" => "option 2"})
    #
    # @example hash with "value" and "display" keys
    #   Downup::Base.new(options: {"a" => {"value" => "option 1", "display" => "Option 1"}})
    #
    # @example header_proc example
    #   Downup::Base.new(options: [], header_proc: Proc.new {puts "Hello"})
    def initialize(options:,
                   flash_message:         nil,
                   flash_color:           :green,
                   default_color:         :brown,
                   selected_color:        :magenta,
                   multi_select_selector: "√",
                   selector:              "‣",
                   type:                  :default,
                   stdin:                 $stdin,
                   stdout:                $stdout,
                   header_proc:           Proc.new{})

      @options                  = options
      @flash_color              = flash_color
      @flash_message            = flash_message
      @default_color            = default_color
      @selected_color           = selected_color
      @selector                 = selector
      @type                     = type
      @header_proc              = header_proc
      @stdin                    = stdin
      @stdout                   = stdout
      @colonel                  = Kernel
      @multi_select_selector    = multi_select_selector
      @multi_selected_positions = []
    end

    # Prompts the user to make selection from the options
    # the object with initialized with.
    # @param position [Integer] where the selector will start at
    # @return [String] a string of the user's selection
    def prompt(position = 0)
      @selected_position = position_selector(position)
      colonel.system("clear")
      header_proc.call
      print_flash
      Downup::OptionsPrinter.new(
        options: options,
        selected_position: @selected_position,
        multi_selected_positions: @multi_selected_positions,
        multi_select_selector: multi_select_selector,
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
                :multi_select_selector,
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
