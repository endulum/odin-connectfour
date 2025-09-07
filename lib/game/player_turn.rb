require_relative "../prompt"

# making player turns by prompt
module PlayerTurn
  attr_reader :whose_turn

  def take_turn
    @whose_turn = if @whose_turn.nil?
                    @player_one
                  else
                    @whose_turn == @player_one ? @player_two : @player_one
                  end
  end
end
