require_relative "player_init"

require "colorize"

# control of gameplay
class GameLoop
  include PlayerInit

  attr_reader :player_one, :player_two, :play_mode
end
