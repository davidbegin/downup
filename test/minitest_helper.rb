$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'downup'

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters'
reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

