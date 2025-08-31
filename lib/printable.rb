require "colorize"

# print a Connect Four grid to the console
module Printable
  def print
    grid_lines = [
      "  0 1 2 3 4 5 6  ".gray,
      "╓───────────────╖".gray
    ]

    @grid.each_row_reverse do |row|
      grid_lines.push row_string_from(row)
    end

    grid_lines.push "╚═══════════════╝".gray
    grid_lines.join("\n")
  end

  private

  def row_string_from(row)
    row_spaces = ["║ ".gray]

    row.each do |token|
      row_spaces.push token.nil? ? "  " : "● ".colorize(token)
    end

    row_spaces.push "║".gray
    row_spaces.join
  end
end
