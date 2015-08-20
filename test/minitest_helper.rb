$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'downup'
require 'minitest/autorun'
require 'minitest/emoji'
require 'minitest/sound'

# Minitest::Emoji.theme! :random
Minitest::Emoji.theme! :kitties
Minitest::Sound.success = 'success.mp3'
Minitest::Sound.failure = 'pokemon_battle.mp3'
Minitest::Sound.during_test = 'pallet_town.mp3'
