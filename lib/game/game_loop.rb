require_relative "player_init"
require_relative "player_turn"
require_relative "../connect_four_board"

require "colorize"

# control of gameplay
class GameLoop
  include PlayerInit
  include PlayerTurn

  def start
    puts "Welcome to Connect Four".bold
    init_players
    play
  end

  def play
    loop do
      setup_game
      play_game
      break unless prompt_continue
    end
  end

  def setup_game
    @board = ConnectFourBoard.new
    @game_over = false
    @status_text = "The game begins."
    @whose_turn = nil
  end

  def play_game
    loop do
      system("clear")
      puts @board.print
      puts status_text
      break if @game_over

      take_turn
      call_move
    end
  end

  def prompt_continue
    text = build_prompt_continue
    loop do
      answer = Prompt.get_input text
      return answer == "y" if valid_answer?(answer)
    end
  end

  private

  def build_prompt_continue
    player_one_name = @player_one[:name]
    colored_p1_name = player_one_name.colorize(color: @player_one[:color])
    return "#{colored_p1_name}, would you like to play again? (y/n)\n> " if @play_mode == "1p"

    player_two_name = @player_two[:name]
    colored_p2_name = player_two_name.colorize(color: @player_two[:color])
    "#{colored_p1_name} and #{colored_p2_name}, would you like to play again? (y/n)\n> "
  end

  def valid_answer?(answer)
    answers = %w[y n]
    unless answers.include?(answer)
      puts "#{'Input error:'.bold} Please enter 'y' for 'yes' or 'n' for 'no'!"
      return false
    end
    true
  end
end
