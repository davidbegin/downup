require_relative "../lib/downup"

options = [
  "Cat",
  "Dog",
  "Kangaroo"
]

puts "The most basic example"
puts Downup::Base.new(options: options).prompt

puts Downup::Base.new(
  options: options,
  title: "Choose an Animal: \n"
).prompt

def header
  puts "\n\t$$$$$$$$$$$$$$$$$$$$"
  puts "\t$$ AWESOME HEADER $$"
  puts "\t$$$$$$$$$$$$$$$$$$$$\n\n"
end

puts Downup::Base.new(
  options: options,
  title: "Choose an Animal: \n",
  header_proc: method(:header)
).prompt

puts Downup::Base.new(
  options: options,
  default_color: :cyan,
  selected_color: :bg_magenta
).prompt
