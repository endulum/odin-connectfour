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

  def call_move
    if @whose_turn == @player_two && @play_mode == "1p"
      play_computer_move
    else
      prompt_player_move
    end
  end

  def play_computer_move
    #
  end

  def prompt_player_move
    #
  end
end
