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
    text = build_prompt_player_text
    loop do
      column = Prompt.get_input text
      return column if valid_column?(column)
    end
  end

  private

  def build_prompt_player_text
    player_name = @whose_turn[:name]
    colored_name = player_name.colorize(color: @whose_turn[:color])
    player_token = @whose_turn[:color].to_s
    colored_token = player_token.colorize(color: @whose_turn[:color])
    "It's your turn, #{colored_name}. Place a #{colored_token} token in which column?\n> ".bold
  end

  def valid_column?(input)
    error = if !%w[0 1 2 3 4 5 6].include? input
              "please enter a column number 0 through 6!"
            elsif @board.column_full? input.to_i
              "that column is full, choose another!"
            end
    puts "Input error: #{error}".bold if error
    error.nil?
  end
end
