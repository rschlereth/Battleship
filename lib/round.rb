class Round

  def start
    puts "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit."
    start_button = gets
    if start_button = "q"
      puts "Until next time!"
    elsif start_button = "p"

    end
  end

  def computer_placement
    coordinates = []
    letters = ["A", "B", "C", "D"]
    nums = ["1", "2", "3", "4"]
    first_cell = letters.sample + nums.sample
    coordinates << first_cell
    
    cell_index = 0
    r1 = [0, 1, 2, 3].sample
    until cell_index == @ship.length - 1
      if r1 == 0 && coordinates[cell_index][1..-1].to_i > 1
        num = coordinates[cell_index][1..-1].to_i -1
        coordinates << coordinates[cell_index][0] + num.to_s

  end
end
