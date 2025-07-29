require "colorize"
require_relative "player_loop"
require_relative "grid"

class GameLoop
  attr_reader :grid, :whose_turn

  def initialize
    @grid = Grid.new
  end

  def set_players
    player_one_name = init_player_one
    @player_one = PlayerLoop.new(player_one_name, :red, @grid)

    puts "Enter 1 to be in 1-player mode against the computer.\nEnter 2 to be in 2-player mode against a second person."
      .bold
    @is_single_player = single_player?

    player_two_name = init_player_two
    @player_two = @is_single_player ? nil : PlayerLoop.new(player_two_name, :yellow, @grid)
  end

  def switch_whose_turn
    @whose_turn = @whose_turn == @player_one ? @player_two : @player_one
  end

  def init_player_one
    name = validate_name(input("What's your name? > ")) while name.nil?
    puts "Hello, #{name.red}! You will be playing #{'red'.red}."
      .bold
    name
  end

  def single_player?
    mode = validate_mode(input) while mode.nil?
    puts "The computer will play #{'yellow'.yellow}.".bold if mode == "1"
    mode == "1"
  end

  def init_player_two
    return nil if @is_single_player == true

    name = validate_name(input("Second person, what's your name? > ")) while name.nil?
    puts "Hello, #{name.yellow}! You will be playing #{'yellow'.yellow}.".bold
    name
  end

  private

  def validate_name(input_value)
    error = if input_value.empty?
              "please enter a name!"
            elsif input_value.length > 32
              "that name is too long! 32 characters or less, please."
            elsif !/\A[A-Za-z ]+\z/.match?(input_value)
              "your name should contain letters A-Z, a-z only."
            end
    puts "#{'Input error:'.bold} #{error}" if error
    error ? nil : input_value
  end

  def validate_mode(input_value)
    if input_value != "1" && input_value != "2"
      puts "#{'Input error:'.bold} please enter 1 or 2!"
      return nil
    end
    input_value
  end

  def input(prefix_text = "> ")
    print prefix_text.bold
    gets.chomp
  end
end
