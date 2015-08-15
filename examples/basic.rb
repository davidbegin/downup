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
  header_proc: -> { "Choose an Animal: \n" }
).prompt

def header
  puts "\n\t$$$$$$$$$$$$$$$$$$$$"
  puts "\t$$ AWESOME HEADER $$"
  puts "\t$$$$$$$$$$$$$$$$$$$$\n\n"
end

puts Downup::Base.new(
  options: options,
  flash_message: "Choose an Animal: \n",
  flash_color: :red,
  header_proc: method(:header)
).prompt

puts Downup::Base.new(
  options: options,
  default_color: :cyan,
  selected_color: :bg_magenta
).prompt

options = {
  "a" => "Cat",
  "b" => "Dog",
  "c" => "Kangaroo",
  "d" => "Snake",
  "e" => "Eel"
}

puts Downup::Base.new(options: options).prompt

puts Downup::Base.new(
  options: options,
  default_color: :cyan,
  selected_color: :bg_magenta,
  selector: "†"
).prompt

options = {
  "a" => {"value" => "cat_1", "display" => "Cat"},
  "b" => {"value" => "kangaroo_1", "display" => "Kangaroo"},
  "c" => {"value" => "dog_1", "display" => "Dog"}
}

puts Downup::Base.new(options: options).prompt
