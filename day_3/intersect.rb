def wire_paths
  wire_paths = File.readlines("./input.txt").map(&:strip)
  wire_one_path = wire_paths.first.split(",")
  wire_two_path = wire_paths.last.split(",")

  start_point = [0, 0]

  wire_one_data_points = [start_point]
  wire_two_data_points = [start_point]

  wire_one_path.each do |move|
    direction, distance = parse_move(move)
    distance.times do
      last_point = wire_one_data_points.last
      x_pos = last_point.first
      y_pos = last_point.last
      new_x_pos = x_pos + (1 * direction.first)
      new_y_pos = y_pos + (1 * direction.last)
      wire_one_data_points << [new_x_pos, new_y_pos]
    end
  end
  wire_two_path.each do |move|
    direction, distance = parse_move(move)
    distance.times do
      last_point = wire_two_data_points.last
      x_pos = last_point.first
      y_pos = last_point.last
      new_x_pos = x_pos + (1 * direction.first)
      new_y_pos = y_pos + (1 * direction.last)
      wire_two_data_points << [new_x_pos, new_y_pos]
    end
  end

  [wire_one_data_points, wire_two_data_points]
end

def parse_move(move_string)
  dir = move_string.slice(0)
  distance = move_string.slice(1, move_string.length).to_i
  [STRING_DIR_TO_DIRECTION[dir], distance]
end

def find_intersections
  wire_one_data_points, wire_two_data_points = wire_paths
  shared_points = wire_one_data_points & wire_two_data_points
  shared_points.reject! { |(x, y)| x == 0 && y == 0 }
end

def closest_intersection
  intersections = find_intersections
  intersections.min_by { |(x, y)| x.abs + y.abs }
end

def manhattan_dist(point)
  point.first.abs + point.last.abs
end

def minimum_steps
  wire_one_data_points, wire_two_data_points = wire_paths
  intersections = find_intersections
  intersections.map do |intersection|
    one_steps = wire_one_data_points.index(intersection)
    two_steps = wire_two_data_points.index(intersection)
    one_steps + two_steps
  end.min
end

STRING_DIR_TO_DIRECTION = {
  "R" => [1, 0],
  "L" => [-1, 0],
  "U" => [0, 1],
  "D" => [0, -1],
}

if __FILE__ == $PROGRAM_NAME
  puts "The Manhattan Distance of the closest intersection point is #{manhattan_dist(closest_intersection)}"
  puts "The minimum number of steps to get to an intersection is #{minimum_steps}"
end
