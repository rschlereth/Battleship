require 'pry'

def valid_placement?( coordinates)
  valid_pair = 0
  # testing to see if the ship length is the same as the number of cells
  if ship.length != coordinates.count
    return false
  else
    coordinates.each_cons(2) do |cd1, cd2|
      if compare_letters(cd1, cd2) != 0 || compare_letters(cd1, cd2) != -1
        return false
      elsif compare_letters(cd1, cd2) == -1 && compare_numbers(cd1, cd2) != 0
        return false
      elsif compare_letters(cd1, cd2) == 0 && compare_numbers != -1
        return false
      else
        valid_pair += 1
      end
    end
  end
  true if valid_pair == coordinates.count - 1
end

cruiser = Ship.new("Cruiser", 3)
submarine = Ship.new("Submarine", 2)

p valid_placement?(submarine, ["A1", "A2"])
p valid_placement?(cruiser, ["B1", "C1", "D1"])
# def test_method
#   test_array = [1, 2, 3]
#   test_array.each_cons(2).all? do |num1, num2|
#     if num1 - num2 == 0
#       puts "All of them are the same!"
#     elsif num1 - num2 == -1
#       puts "they're off by 1"
#     else
#       false
#     end
#   end
# end
#
# p test_method

# array = [1,2,4,3]
# p array.each_cons(2).all? { |x,y| y == x + 1 }
