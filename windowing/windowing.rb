class Interval
  attr_accessor :x1, :x2
  INTERVALS = []
  def initialize(x1, x2)
    @x1 = x1
    @x2 = x2
    INTERVALS << self
  end
end

class Interval_Tree
  attr_accessor :median, :left_tree, :right_tree, :sort_left, :sort_right
  SOLUTION = []

  def join_x(array_x1, number)
    joined = []
    0.upto((number)-1) do |i|
      joined << array_x1[i].x1
      joined << array_x1[i].x2
    end
    joined.sort!
  end

  def construct_tree(intervals)
    number_of_intervals = intervals.length
    if number_of_intervals == 0
      return nil
    else
      node = Interval_Tree.new
      joined = join_x(intervals, number_of_intervals)
      node.median = joined[number_of_intervals]
      s_center = []
      s_left = []
      s_right = []

      intervals.each do |i|
        case
          when i.x2 < node.median
            s_left << i
          when i.x1 > node.median
            s_right << i
          else
            s_center << i
        end
      end
      node.sort_left = s_center.sort_by(&:x1)
      node.sort_right = s_center.sort_by(&:x2).reverse!
      node.left_tree = construct_tree(s_left)
      node.right_tree = construct_tree(s_right)
      node
    end
  end

  def query_tree(tree, y)
    if tree != nil
      if y <= tree.median
        0.upto((tree.sort_left.length)-1) do |i|
          if y >= tree.sort_left[i].x1 && y <= tree.sort_left[i].x2
            SOLUTION << tree.sort_left[i]
          end
        end
        query_tree(tree.left_tree ,y)
      else
        0.upto((tree.sort_right.length)-1) do |i|
          if y >= tree.sort_left[i].x1 && y <= tree.sort_left[i].x2
            SOLUTION << tree.sort_left[i]
          end
        end
        query_tree(tree.right_tree ,y)
      end
    SOLUTION
    end
  end

  def generate_intervals(array)
    0.upto((array.length)-1) do |i|
      v = array[i]
      Interval.new(v[0], v[1])
    end
  end
end

VECTORS = [
    [1,5],
    [3,7],
    [2,3],
    [8,9],
    [6,9],
    [2,4],
    [3,6],
    [7,8]
]
tree = Interval_Tree.new
tree.generate_intervals(VECTORS)
sorted = Interval::INTERVALS.sort_by(&:x1)
puts 'Odcinki'
0.upto(7) do |i|
  puts "[#{sorted[i].x1}, #{sorted[i].x2}]"
end
y = 6
solution = tree.query_tree(tree.construct_tree(Interval::INTERVALS), y)
puts 'Rozwiazanie'
0.upto((solution.length)-1) do |i|
  puts "[#{solution[i].x1}, #{solution[i].x2}]"
end