class Polygon
  VERTEX_X = []
  VERTEX_Y = []

  def check_if_inside(point, number)
    i = 0
    j = number - 1
    inside = false
    while i < number do
      if ((VERTEX_Y[i] > point[1]) != (VERTEX_Y[j] > point[1])) && ((point[0] < (VERTEX_X[j]-VERTEX_X[i]) * (point[1]-VERTEX_Y[i]) / (VERTEX_Y[j]-VERTEX_Y[i]) + VERTEX_X[i]))
        inside = !inside
      end
      j = i
      i += 1
    end
    inside
  end

  def get_point
    puts 'Podaj X punku do sprawdzenia: '
    x = gets.chomp.to_f
    puts 'Podaj Y punku do sprawdzenia: '
    y = gets.chomp.to_f
    point = [x,y]
    point
  end

  def add_vectors(number)
    loop_count = 0
    while loop_count < number do
      puts "Podaj X #{loop_count + 1} wierzchołka"
      VERTEX_X << gets.chomp.to_f
      puts "Podaj Y #{loop_count + 1} wierzchołka"
      VERTEX_Y << gets.chomp.to_f
      loop_count += 1
    end
    point = get_point
    check_if_inside(point, number)
  end

  def start
    puts 'Podaj liczbę wierzchołków wielokąta (min 3): '
    number = gets.chomp.to_i
    until number > 2
      puts 'Wprowadź poprawną ilość'
      number = gets.chomp.to_i
    end
    result = add_vectors number
    puts "Punkt w środku? - #{result} "
  end
end

polygon = Polygon.new
polygon.start
