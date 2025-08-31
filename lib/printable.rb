require "colorize"

# print a Connect Four grid to the console
module Printable
  def print
    grid_string = "#{'  0 1 2 3 4 5 6  '.gray}\n#{'╓───────────────╖'.gray}\n"
    (@grid.row_count - 1).downto(0) do |height|
      grid_string += "#{row_string_from(height)}\n"
      next unless height.zero?

      grid_string += "╚═══════════════╝".gray
    end
    grid_string
  end

  private

  def row_string_from(height)
    row_string = "║ ".gray
    @grid.column_count.times do |column|
      row_string += space_string_from(column, height)
    end
    row_string
  end

  def space_string_from(column, height)
    space_string = ""

    space = @grid.at(column, height)
    space_string += space.nil? ? " " : "●".colorize(space)

    is_last_space = column == @grid.column_count - 1
    space_string += is_last_space ? " ║".gray : " "

    space_string
  end
end
