require_relative "../prompt"

# making player turns by prompt
module PlayerTurn
  attr_reader :whose_turn, :status_text

  def take_turn
    @whose_turn = if @whose_turn.nil?
                    @player_one
                  else
                    @whose_turn == @player_one ? @player_two : @player_one
                  end
  end

  def call_move
    if @whose_turn == @player_two && @play_mode == "1p"
      play_move(prompt_computer_move)
    else
      play_move(prompt_player_move)
    end
  end

  def play_move(column)
    coords = @board.drop_token(@whose_turn[:color], column)
    winning_move = @board.winning_move?(coords, @whose_turn[:color])
    @status_text = build_status_text(column, winning_move)
    @game_over = winning_move
  end

  def prompt_computer_move
    puts build_computer_thinking_text
    sleep 2
    loop do
      column = rand(0..6)
      return column unless @board.column_full?(column)
    end
  end

  def prompt_player_move
    text = build_prompt_player_text
    loop do
      column = Prompt.get_input text
      return column.to_i if valid_column?(column)
    end
  end

  private

  def build_status_text(column, winning_move)
    player_name = @whose_turn[:name]
    colored_name = player_name.colorize(color: @whose_turn[:color])
    player_token = @whose_turn[:color].to_s
    colored_token = player_token.colorize(color: @whose_turn[:color])
    text = "#{colored_name} placed a #{colored_token} token in column #{column}."
    text += " #{colored_name} got four in a row!" if winning_move
    text
  end

  def build_prompt_player_text
    player_name = @whose_turn[:name]
    colored_name = player_name.colorize(color: @whose_turn[:color])
    player_token = @whose_turn[:color].to_s
    colored_token = player_token.colorize(color: @whose_turn[:color])
    "It's your turn, #{colored_name}. Place a #{colored_token} token in which column?\n> ".bold
  end

  def build_computer_thinking_text
    player_name = @whose_turn[:name]
    colored_name = player_name.colorize(color: @whose_turn[:color])
    "#{colored_name} is thinking...".bold
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
