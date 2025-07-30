require "colorize"

class Grid
  attr_reader :column_count, :column_height

  def initialize(column_count = 7, column_height = 6)
    @column_count = column_count
    @column_height = column_height
    reset
  end

  def reset
    empty_column = Array.new(column_height, nil)
    @columns = []
    column_count.times { @columns.push(empty_column.dup) }
  end

  ## getting grid info

  def at(coords)
    @columns[coords[0]][coords[1]]
    # [0, 0] = left bottom corner
    # [@column_count, @column_height] = right top corner
    # [0, @column_height] = left top corner
    # [@column_count, 0] = right bottom corner
  end

  def each
    @column_count.times do |column_index|
      @column_height.times do |row_index|
        yield at([column_index, row_index]), [column_index, row_index]
        # this.each do |value, coords|
      end
    end
  end

  def at_column(index)
    @columns[index]
  end

  def each_column
    @column_count.times do |column_index|
      yield at_column(column_index), column_index
      # this.each do |column, index|
    end
  end

  ## adding tokens to grid

  def self.valid_token?(token)
    String.colors.include?(token)
    # tokens need to be Colorize symbols to allow printing
  end

  def set_space(coords, token)
    return unless Grid.valid_token?(token)

    @columns[coords[0]][coords[1]] = token
  end

  def column_full?(index)
    at_column(index).compact.length == at_column(index).length
  end

  def drop_token(token, column_index)
    return if column_full?(column_index)

    row = 0
    (0..5).each do |row_index|
      next unless at([column_index, row_index]).nil?

      set_space([column_index, row_index], token)
      row = row_index
      break
    end
    [column_index, row]
  end

  ## displaying grid

  def print
    grid_string = "#{'╓───────────────╖'.gray}\n"
    (@column_height - 1).downto(0) do |height|
      grid_string += "#{row_string_from(height)}\n"
      next unless height.zero?

      grid_string += "╚═══════════════╝".gray
    end
    grid_string
  end

  ## determining winning move

  @@directions_matrix = {
    vertical: { south: [1, 0], north: [-1, 0] },
    horizontal: { east: [0, 1], west: [0, -1] },
    backward: { southeast: [1, 1], northwest: [-1, -1] },
    forward: { southwest: [1, -1], northeast: [-1, 1] }
  }

  def winning_move?(coords, token)
    is_match = false
    @@directions_matrix.each_value do |axis|
      matches = 1
      axis.each_value do |direction|
        cell_reference = [coords[1], coords[0]]
        test_cell = at [cell_reference[1], cell_reference[0]]

        while test_cell == token
          cell_reference[0] += direction[0]
          cell_reference[1] += direction[1]
          test_cell = at [cell_reference[1], cell_reference[0]]
          matches += 1 unless test_cell != token
        end
      end
      is_match = matches >= 4
      break if is_match
    end
    is_match
  end
  # https://stackoverflow.com/a/63446171

  private

  def row_string_from(height)
    row_string = "║ ".gray
    @column_count.times do |column|
      row_string += space_string_from(column, height)
    end
    row_string
  end

  def space_string_from(column, height)
    space_string = ""

    space = at([column, height])
    space_string += space.nil? ? " " : "●".colorize(space)

    is_last_space = column == @column_count - 1
    space_string += is_last_space ? " ║".gray : " "

    space_string
  end
end
