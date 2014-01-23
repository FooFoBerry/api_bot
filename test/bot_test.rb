require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/api_bot'
require 'pry'

class ApiBotTest < Minitest::Test
  def test_can_make_commits
    bot = ApiBot.new
    response = bot.make_commit
    assert_equal response.status, 201
  end

  def test_can_make_tracker_events
    bot = ApiBot.new
    response = bot.make_tracker_event
    assert_equal response.status, 201
  end
end
