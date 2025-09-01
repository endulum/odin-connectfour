# determine whether a space in a x,y grid is part of an n-in-a-row match
module Matchable
  DIRECTIONS_MATRIX = {
    vertical: { south: [1, 0], north: [-1, 0] },
    horizontal: { east: [0, 1], west: [0, -1] },
    backward: { southeast: [1, 1], northwest: [-1, -1] },
    forward: { southwest: [1, -1], northeast: [-1, 1] }
  }.freeze

  def match_at?(coords, target_value, match_length)
    is_match = false
    DIRECTIONS_MATRIX.each_value do |axis|
      match_count = matches_from_axis(coords, target_value, axis)
      is_match = match_count >= match_length
      break if is_match
    end
    is_match
  end

  private

  def matches_from_axis(coords, target_value, axis)
    axial_match_count = 1

    axis.each_value do |direction|
      axial_match_count += matches_from_direction(coords, target_value, direction)
    end

    axial_match_count
  end

  def matches_from_direction(coords, target_value, direction)
    directional_match_count = 0
    current_coords = [*coords]
    current_value = at(*current_coords)

    while current_value == target_value
      current_coords = offset_coords(*current_coords, *direction)
      current_value = at(*current_coords)
      directional_match_count += 1 unless current_value != target_value
    end

    directional_match_count
  end

  def offset_coords(x_coord, y_coord, x_offset, y_offset)
    [x_coord + x_offset, y_coord + y_offset]
  end
end
