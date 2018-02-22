Item = Struct.new(:name, :weight, :value)

def create_backpack(items, max_weight)
  number_of_items = items.size
  backpack_values = Array.new(number_of_items){Array.new(max_weight+1, 0)}

  number_of_items.times do |i|
    (max_weight + 1).times do |j|
      if(items[i].weight > j)
        backpack_values[i][j] = backpack_values[i-1][j]
      else
        backpack_values[i][j] = [backpack_values[i-1][j], items[i].value + backpack_values[i-1][j-items[i].weight]].max
      end
    end
  end
  best_value = get_used_items(items, backpack_values)
  [get_list_of_used_items_names(items, best_value),
   items.zip(best_value).map{|item,used| item.weight*used}.inject(:+),
   backpack_values.last.last]
end

def get_used_items(items, backpack_values)
  i = backpack_values.size - 1
  current_cost = backpack_values[0].size - 1
  used = backpack_values.map{0}

  while(i >= 0 && current_cost >= 0)
    if(i == 0 && backpack_values[i][current_cost] > 0 ) || (backpack_values[i][current_cost] != backpack_values[i-1][current_cost])
      used[i] = 1
      current_cost -= items[i].weight
    end
    i -= 1
  end
  used
end

def get_list_of_used_items_names(items, used_items)
  items.zip(used_items).map{|item,used| item.name if used>0}.compact.join(', ')
end

ITEMS = [
    Item['1', 6, 5],
    Item['2', 3, 1],
    Item['3', 4, 4],
    Item['4', 2, 2]
  ]

names, weight, value = create_backpack(ITEMS, 10)
puts "Used items: #{names}"
puts "Backpack weight: #{weight}"
puts "Backpack value: #{value}"
