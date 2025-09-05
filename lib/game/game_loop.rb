require_relative "player_init"
require_relative "../connect_four_board"

require "colorize"

# control of gameplay
class GameLoop
  include PlayerInit

  attr_reader :player_one, :player_two, :play_mode, :board, :whose_turn

  def begin_game
    @board = ConnectFourBoard.new
    @whose_turn = player_one
  end
end
