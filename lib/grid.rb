class Grid
  def initialize
    empty_column = Array.new(6, nil)
    @columns = []
    7.times { @columns.push(empty_column.dup) }
  end

  def column(index)
    @columns[index]
  end

  def column_full?(index)
    @columns[index].compact.length == @columns[index].length
  end

  def at_space(column_index, column_position)
    @columns[column_index][column_position]
  end

  def set_space(column_index, column_position, token)
    @columns[column_index][column_position] = token
  end

  def drop_token(token, column_index)
    (0..5).each do |column_position|
      if at_space(column_index, column_position).nil?
        set_space(column_index, column_position, token)
        break
      end
    end
  end
end
