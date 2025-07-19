require_relative "grid"

class GameLoop
  def initialize
    @player_one_name = init_player_one
    @is_single_player = init_player_mode
    @player_two_name = init_player_two
  end
end
