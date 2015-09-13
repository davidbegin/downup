# Downup

[![Gem Version](https://badge.fury.io/rb/downup.svg)](http://badge.fury.io/rb/downup) [![Build Status](https://travis-ci.org/presidentJFK/downup.svg?branch=master)](https://travis-ci.org/presidentJFK/downup) [![Test Coverage](https://codeclimate.com/github/presidentJFK/downup/badges/coverage.svg)](https://codeclimate.com/github/presidentJFK/downup/coverage) [![Code Climate](https://codeclimate.com/github/presidentJFK/downup/badges/gpa.svg)](https://codeclimate.com/github/presidentJFK/downup) [![Dependency Status](https://gemnasium.com/presidentJFK/downup.svg)](https://gemnasium.com/presidentJFK/downup) [![Inline docs](http://inch-ci.org/github/presidentJFK/downup.svg?branch=master)](http://inch-ci.org/github/presidentJFK/downup)

### \*\*WARNING THIS GEM IS PRE 1.0 AND STILL UNSTABLE\*\*

A simple gem for creating command line menus you can use the arrows
to move through.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'downup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install downup

## Usage

[Runnable Examples](examples/basic.rb)

```ruby
options = [
  "Dog",
  "Cat",
  "Kangaroo"
]

Downup::Base.new(options: options).prompt

# You can also pass a flash message and color when initializing
Downup::Base.new(options: options, flash_color: :green, flash_message: "Animals: \n").prompt

# you can pass a callable header
# to print out before the menu

def header
  puts "\n=========="
  puts "= HEADER ="
  puts "==========\n"
end

Downup::Base.new(options: options, header_proc: method(header)).prompt

# You can also change the default and selected color,
# your options are as follows

COLOR_OPTIONS = [
  :black
  :red
  :green
  :brown
  :blue
  :magenta
  :cyan
  :gray
  :bg_black
  :bg_red
  :bg_green
  :bg_brown
  :bg_blue
  :bg_magenta
  :bg_cyan
  :bg_gray
  :bold
  :reverse_color
]

Downup::Base.new(
  options: options,
  default_color: :bg_gray,
  selected_color: :cyan
).prompt

# You can also pass in a hash, and then quickly jump around,
# but the key
options = {
  "a" => "Cat",
  "b" => "Dog",
  "c" => "Kangaroo",
  "d" => "Snake",
  "e" => "Eel"
}

puts Downup::Base.new(options: options).prompt

# You can also specifiy a different value from display
options = {
  "a" => {"value" => "cat_1", "display" => "Cat"},
  "b" => {"value" => "kangaroo_1", "display" => "Kangaroo"},
  "c" => {"value" => "dog_1", "display" => "Dog"}
}

puts Downup::Base.new(options: options).prompt

# You can also pass in the selector you would like
# if passing in a hash
puts Downup::Base.new(options: options, selector: "†").prompt

# You can also enable multi_select,
Downup::Base.new(options: options, type: :multi_select).prompt

# You can customize the Multi Select Selector
Downup::Base.new(
  options: options,
  type: :multi_select,
  multi_select_selector: "X",
  selected_color: :red
).prompt
```

## Inspired By

This Gist
https://gist.github.com/acook/4190379

and this Stack Overflow article
http://stackoverflow.com/questions/1489183/colorized-ruby-output

To run specs

```ruby
rake test
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/downup/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
