class Point
  attr_accessor :x, :y
  POINTS = []
  def initialize(x, y)
    @x = x
    @y = y
    POINTS << self
  end
end

class Counting
  def generate_points(number)
    1.upto(number) do |i|
      p = Point.new(rand(20), rand(20))
      puts "Punkt #{i}: (#{p.x},#{p.y}) "
    end
  end

  def distance_between(p1, p2)
    Math.hypot(p1.x - p2.x, p1.y - p2.y)
  end

  def nearest_brute_force(points)
    min_dist, min_points = Float::MAX, []
    points.combination(2) do |pi, pj|
      distance = distance_between(pi, pj)
      if distance < min_dist
        min_dist = distance
        min_points = [pi, pj]
      end
    end
    [min_dist, min_points]
  end

  def nearest_points(sorted_by_x, sorted_by_y)
    return nearest_brute_force(sorted_by_x) if sorted_by_x.length <= 3
    middle = sorted_by_x.length / 2
    middle_point_x = sorted_by_x[middle].x
    distance_left, nearest_points_left = nearest_points(sorted_by_x[0, middle], sorted_by_y)
    distance_right, nearest_points_right = nearest_points(sorted_by_x[middle..-1], sorted_by_y)
    min_distance, min_points = distance_left < distance_right ? [distance_left, nearest_points_left] : [distance_right, nearest_points_right]
    good_y = sorted_by_y.find_all {|p| sorted_by_x.include?(p) && (middle_point_x - p.x).abs < min_distance}
    nearest_distance, nearest_points = min_distance, min_points
    0.upto(good_y.length - 2) do |i|
      (i + 1).upto(good_y.length - 1) do |k|
        break if (good_y[k].y - good_y[i].y) >= min_distance
        dist = distance_between(good_y[i], good_y[k])
        if dist < nearest_distance
          nearest_distance = dist
          nearest_points = [good_y[i], good_y[k]]
        end
      end
    end
    [nearest_distance, nearest_points]
  end
end

c = Counting.new
puts 'Ile punktów wygenerować?'
c.generate_points(gets.chomp.to_i)
sorted_by_x = Point::POINTS.sort_by(&:x)
sorted_by_y = sorted_by_x.sort_by(&:y)
answer = c.nearest_points(sorted_by_x, sorted_by_y)
puts "Odleglość pomiędzy najbliższymi punktami: #{answer[0]}"
puts "Współrzędne tych punktów: #{answer[1]}"
