# Downup

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

# You can also pass a title when initializing
Downup::Base.new(options: options, title: "Animals: \n").prompt

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
```

## Inspired By

This gist
https://gist.github.com/acook/4190379

and this SO article
http://stackoverflow.com/questions/1489183/colorized-ruby-output


## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/downup/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
