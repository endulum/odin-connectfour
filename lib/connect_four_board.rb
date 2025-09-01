require_relative "grid"
require_relative "printable"
require "colorize"

# the game board for Connect Four
class ConnectFourBoard
  include Printable

  attr_reader :grid

  def initialize
    @grid = Grid.new(7, 6)
  end

  def self.valid_token?(token)
    String.colors.include?(token)
    # tokens need to be Colorize symbols because the grid will be printed.
  end

  def column_full?(index)
    column = @grid.at_column(index)
    column.compact.length == column.length
  end

  def drop_token(token, column_index)
    return if column_full?(column_index) || !self.class.valid_token?(token)

    column = @grid.at_column(column_index)
    row_index = column.index(&:nil?) # find first nil in column
    @grid.set_value_at(column_index, row_index, token)
    [column_index, row_index]
  end

  def winning_move?(coords, token)
    @grid.match_at?(coords, token, 4)
  end
end
