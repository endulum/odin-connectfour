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

  def column(index)
    @columns[index]
  end

  def at_space(column_index, column_position)
    @columns[column_index][column_position]
  end

  def self.valid_token?(token)
    String.colors.include?(token)
  end

  def set_space(column_index, column_position, token)
    return unless Grid.valid_token?(token)

    @columns[column_index][column_position] = token
  end

  def column_full?(index)
    @columns[index].compact.length == @columns[index].length
  end

  def drop_token(token, column_index)
    return if column_full?(column_index)

    (0..5).each do |column_position|
      if at_space(column_index, column_position).nil?
        set_space(column_index, column_position, token)
        break
      end
    end
  end

  def print
    grid_string = "#{'╓───────────────╖'.gray}\n"
    (@column_height - 1).downto(0) do |height|
      grid_string += "#{row_string_from(height)}\n"
      next unless height.zero?

      grid_string += "╚═══════════════╝".gray
    end
    grid_string
  end

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

    space = at_space(column, height)
    space_string += space.nil? ? " " : "●".colorize(space)

    is_last_space = column == @column_count - 1
    space_string += is_last_space ? " ║".gray : " "

    space_string
  end
end
