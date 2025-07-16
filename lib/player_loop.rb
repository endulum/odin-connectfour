require "colorize"

class PlayerLoop
  attr_reader :name, :color, :grid

  def initialize(name, color, grid)
    @name = name
    @color = color
    @grid = grid
  end

  def play_turn
    chosen_column = to_column_choice(input) while chosen_column.nil?
    chosen_column
  end

  def to_column_choice(input_value)
    unless /^[0-6]$/.match?(input_value)
      puts "Input error: Not a valid column. Please input an integer 0 to 6."
      return nil
    end

    column_choice = input_value.to_i
    if @grid.column_full?(column_choice)
      puts "Input error: This column is full. Please select another column."
      return nil
    end

    column_choice
  end

  def input
    print "\n#{@name.colorize(@color)} will drop their token in: ".colorize({ mode: bold })
    gets.chomp
  end
end
