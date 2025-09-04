require_relative "../prompt"

# initializing player one, player two, and player mode by input
module PlayerInit
  def init_player_one
    loop do
      name = Prompt.get_input("What is your name? > ")
      next unless valid_name?(name)

      puts "Hello, #{name.red}. You will be playing #{'red'.red}.".bold
      return { name: name, color: :red }
    end
  end

  def init_play_mode
    loop do
      mode = Prompt.get_input(
        "Enter '1p' to play against the computer.\n Enter '2p' to play against a second person.\n> ".bold
      )
      return mode if valid_mode?(mode)
    end
  end

  def init_cpu_player
    puts "The computer will play #{'yellow'.yellow}.".bold
    { name: "The Computer", color: :yellow }
  end

  def init_player_two
    loop do
      name = Prompt.get_input("Second player, what is your name? > ")
      next unless valid_name?(name)

      puts "Hello, #{name.yellow}. You will be playing #{'yellow'.yellow}.".bold
      return { name: name, color: :yellow }
    end
  end

  def init_players
    @player_one = init_player_one
    @play_mode = init_play_mode
    @player_two = @play_mode == "1p" ? init_cpu_player : init_player_two
  end

  private

  def valid_name?(name)
    error = if name.empty?
              "please enter a name!".bold
            elsif name.length > 32
              "that name is too long! 32 characters or less, please.".bold
            elsif !/\A[A-Za-z ]+\z/.match?(name)
              "your name should contain letters A-Z, a-z only.".bold
            end
    puts "#{'Input error:'.bold} #{error}" if error
    error.nil?
  end

  def valid_mode?(mode)
    modes = %w[1p 2p]
    unless modes.include?(mode)
      puts "#{'Input error:'.bold} Please enter '1p' or '2p'!"
      return false
    end
    true
  end
end
