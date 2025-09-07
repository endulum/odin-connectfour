require_relative "player_init"
require_relative "player_turn"
require_relative "../connect_four_board"

require "colorize"

# control of gameplay
class GameLoop
  include PlayerInit
  include PlayerTurn
end
