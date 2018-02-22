class Point
  attr_accessor :x, :y, :chain
  VERTEXES = []
  def initialize(x, y)
    @x = x
    @y = y
    VERTEXES << self
  end
end

class Triangulation
  def get_orientation(polygon)
    sum = 0
    0.upto(polygon.length-1) do |i|
      sum += if i == polygon.length - 1
               (polygon[0].x - polygon[i].x) * (polygon[0].y + polygon[i].y)
             else
               (polygon[i + 1].x - polygon[i].x) * (polygon[i + 1].y + polygon[i].y)
             end
    end
    orientation = 'clockwise' if sum >= 0
    orientation = 'counterclockwise' if sum < 0
    orientation
  end

  def load_points(array)
    0.upto(array.length - 1) do |i|
      v = array[i]
      Point.new(v[0], v[1])
    end
  end

  def divide_chains(array)
    0.upto(array.length - 1) do |i|
      array[i].chain = if i == array.length - 1 && array[0].x > array[i].x
                         1
                       elsif i == array.length - 1 && array[0].x < array[i].x
                         2
                       elsif array[i + 1].x > array[i].x
                         1
                       else
                         array[i].chain = 2
                       end
    end
  end

  def get_diagonal_orientation(p1, p2, p3)
    sign = p1.x * p2.y + p2.x * p3.y + p3.x * p1.y - p2.x * p1.y - p3.x * p2.y - p1.x * p3.y
    orientation = 'clockwise' if sign < 0
    orientation = 'counterclockwise' if sign >= 0
    orientation
  end

  def triangulate(vertices)
    orientation = get_orientation(Point::VERTEXES)
    diagonals = []
    heap = [vertices[0], vertices[1]]
    puts "Stos startowy = #{heap}"
    2.upto(vertices.length - 2) do |i|
      puts "Rozpatrujemy wierzchołek = [#{vertices[i].x},#{vertices[i].y}]"
      if vertices[i].chain != heap[-1].chain
        1.upto(heap.length - 1) do |k|
          diagonals << [heap[k], vertices[i]]
          puts "Dodano diagonale = #{[heap[k], vertices[i]]}"
        end
        heap = [vertices[i - 1], vertices[i]]
      else
        diagonal_orientation = get_diagonal_orientation(heap[-2], heap[-1], vertices[i])
        last = heap.pop
        while orientation == diagonal_orientation && heap != []
          diagonals << [heap[-1], vertices[i]]
          puts "Dodano diagonale = #{[heap[-1], vertices[i]]}"
          last = heap.pop
        end
        heap << last if last != []
        heap << vertices[i]
        puts "Stos: #{heap}"
      end
    end
    heap.slice!(0)
    heap.slice!(-1)
    until heap == []
      diagonals << [heap[-1], vertices[-1]]
      puts "Dodano diagonale = #{[heap[-1], vertices[-1]]}"
      heap.pop
    end
    print_diagonals(diagonals)
  end

  def print_diagonals(diagonals)
    0.upto(diagonals.length - 1) do |i|
      puts "Przekątna #{i} = #{diagonals[i]}"
    end
  end
end

EDGES = [
  [5, 3],
  [7, 1],
  [6, 1.5],
  [4, 1],
  [1, 2],
  [2.5, 2.5],
  [3, 3]
].freeze
EDGES1 = [
  [11, 0],
  [17, 2],
  [21, 6],
  [24, 10],
  [22, 14],
  [18, 18],
  [12, 20],
  [6, 18],
  [2, 14],
  [0, 10],
  [1, 6],
  [5, 2]
].freeze
EDGES2 = [
  [1, 0],
  [2, 4],
  [3, 1],
  [4, 1],
  [5, 4],
  [6, 1],
  [7, 1],
  [8, 4],
  [9, 1],
  [10, 1],
  [11, 4],
  [12, 1],
  [13, 1],
  [14, 4],
  [15, 0]
].freeze
EDGES3 = [
  [0, 0],
  [26, 0],
  [24, 24],
  [23, 21],
  [22, 16],
  [19, 13],
  [18, 10],
  [15, 9],
  [14, 6],
  [11, 5],
  [8, 2],
  [4, 2]
].freeze

triang = Triangulation.new
triang.load_points(EDGES1)
sorted_by_x = Point::VERTEXES.sort_by(&:x)
# debug
# 0.upto(sorted_by_x.length - 1) do |i|
#   puts "[#{sorted_by_x[i].x},#{sorted_by_x[i].y}]"
# end
triang.divide_chains(Point::VERTEXES)
# debug
# 0.upto(sorted_by_x.length - 1) do |i|
#   puts "[#{Point::VERTEXES[i].x},#{Point::VERTEXES[i].y}, chain = #{Point::VERTEXES[i].chain}]"
# end
triang.triangulate(sorted_by_x)
