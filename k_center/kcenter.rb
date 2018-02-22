class Point
  attr_accessor :x, :y
  POINTS = []
  def initialize(x, y)
    @x = x
    @y = y
    POINTS << self
  end
end

class KCenter

  def load_points(array)
    0.upto((array.length)-1) do |i|
      v = array[i]
      Point.new(v[0], v[1])
    end
  end

  def gonzalez_k_center(points, k)
    distance = Array.new(k)
    answer = Array.new(k)
    answer[0] = points[0]
    distance_pom = Array.new(points.size)
    0.upto((distance_pom.size)-1) do |i|
      distance_pom[i] = Float::MAX
    end
    0.upto(k-1) do |i|
      distance[i] = 0
      0.upto((points.size)-1) do |j|
        pom_X = points[j].x-answer[i].x
        pom_Y = points[j].y-answer[i].y
        distance_pom[j] = [distance_pom[j], pom_X*pom_X + pom_Y*pom_Y ].min
        if distance[i] < distance_pom[j]
          distance[i] = distance_pom[j];
          answer[i+1] = points[j]
        end
      end
    end
    answer
  end
end

DATA = [
    [3, 7],
    [1, 3],
    [1, 9],
    [4, 14],
    [6, 1],
    [7, 6],
    [8, 11],
    [9, 10],
    [10, 3],
    [10, 13],
    [11, 7],
    [13, 5],
    [15, 9],
    [16, 2],
    [17, 8],
    [17, 11]
]
k = 3
center = KCenter.new
center.load_points(DATA)
answer = center.gonzalez_k_center(Point::POINTS,k)
0.upto(k-1) do |i|
  puts "[#{answer[i].x},#{answer[i].y}]"
end
