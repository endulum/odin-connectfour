class PlayerLoop
  attr_reader :name, :color, :grid

  def initialize(name, color, grid)
    @name = name
    @color = color
    @grid = grid
  end

  # def play_turn
  #   loop do
  #     @last_move = verify(input)
  #     break if @last_move

  #     puts "Not a valid input!"
  #   end
  # end
end
