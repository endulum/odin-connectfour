require_relative "matchable"

# a two-dimensional grid accessible and manipulable by x,y coordinates
class Grid
  include Matchable

  attr_reader :values, :column_count, :row_count

  def initialize(columns, rows)
    @column_count = columns
    @row_count = rows
    @values = Array.new(columns) { Array.new(rows) }
  end

  def at(column, row)
    values.dig(column, row)
  end

  def set_value_at(column, row, value)
    return unless column < @column_count && row < @row_count

    values[column][row] = value
  end

  def each
    @column_count.times do |column_index|
      @row_count.times do |row_index|
        yield at(column_index, row_index), [column_index, row_index]
        # usage: this.each do |value, coords| ...
      end
    end
  end

  def map
    mapped = []
    each do |value|
      block_given? ? mapped.push(yield value) : mapped.push(value)
    end
    mapped
  end

  def at_column(index)
    values[index]
  end

  def each_column
    @column_count.times do |column_index|
      yield at_column(column_index), column_index
      # usage: this.each_column do |column, index| ...
    end
  end

  def at_row(index)
    row = []
    each_column { |column| row.push column[index] }
    row
  end

  def each_row
    @row_count.times do |row_index|
      yield at_row(row_index), row_index
      # usage: this.each_row do |row, index| ...
    end
  end
end
