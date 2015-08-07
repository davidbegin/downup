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

```ruby
options = [
  "Dog",
  "Cat",
  "Kangaroo"
]

Downup::Base.new(options: options).prompt

# You can also pass a title when initializing
Downup::Base.new(options: options, title: "Animals: \n").prompt
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
