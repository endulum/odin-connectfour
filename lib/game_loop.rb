require "colorize"
require "pry-byebug"

class GameLoop
  def initialize
  end

  def set_players
    @player_one_name = init_player_one

    puts "Enter 1 to be in 1-player mode against the computer.\nEnter 2 to be in 2-player mode against a second person."
      .colorize({ mode: :bold })
    @is_single_player = init_player_mode

    @player_two_name = init_player_two
  end

  def init_player_one
    name = validate_name(input("What's your name? > ")) while name.nil?
    puts "Hello, #{name.colorize(:red)}! You will be playing #{'red'.colorize(:red)}."
      .colorize(mode: :bold)
    name
  end

  def init_player_mode
    mode = validate_mode(input) while mode.nil?
    puts "The computer will play #{'yellow'.colorize(:yellow)}.".colorize(mode: :bold) if mode == "1"
    mode == "1"
  end

  def init_player_two
    return nil if @is_single_player == true

    name = validate_name(input("Second person, what's your name? > ")) while name.nil?
    puts "Hello, #{name.colorize(:yellow)}! You will be playing #{'yellow'.colorize(:yellow)}."
      .colorize({ mode: :bold })
    name
  end

  def validate_name(input_value)
    if input_value.empty?
      puts "#{'Input error:'.colorize(mode: :bold)} please enter a name!"
      return nil
    elsif input_value.length > 32
      puts "#{'Input error:'.colorize(mode: :bold)} that name is too long! 32 characters or less, please."
      return nil
    elsif !input_value.match(/^[A-Za-z ]+$/)
      puts "#{'Input error:'.colorize(mode: :bold)} your name should contain letters A-Z, a-z only."
      return nil
    end
    input_value
  end

  def validate_mode(input_value)
    if input_value != "1" && input_value != "2"
      puts "#{'Input error:'.colorize(mode: :bold)} please enter 1 or 2!"
      return nil
    end
    input_value
  end

  def input(prefix_text = "> ")
    print prefix_text.colorize({ mode: :bold })
    gets.chomp
  end
end
