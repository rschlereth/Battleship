class Round

  def initialize(board_computer, board_player)
    @board_computer = board_computer
    @board_player = board_player
  end

  def start
    puts "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit."
    start_button = gets.strip
    if start_button.downcase == "q"
      puts "See you next time!"

    # Computer Ship Placement
    elsif start_button.downcase == "p"
      submarine_c = Ship.new("Submarine", 2)
      cruiser_c = Ship.new("Cruiser", 3)
      @submarine_coords_c = computer_placement(submarine_c)
      @cruiser_coords_c = computer_placement(cruiser_c)
      valid_placement = 0
      until valid_placement == 1
        if @board_computer.valid_placement?(submarine_c, @submarine_coords_c)
          @board_computer.place(submarine_c, @submarine_coords_c)
          valid_placement += 1
          binding.pry
        else
          @submarine_coords_c = computer_placement(submarine_c)
          binding.pry
        end
      end
      until valid_placement == 2
        if @board_computer.valid_placement?(cruiser_c, @cruiser_coords_c)
          @board_computer.place(cruiser_c, @cruiser_coords_c)
          valid_placement += 1
        else
          @cruiser_coords_c = computer_placement(cruiser_c)
        end
      end
    else
      puts "Womp womp invalid letter :(\n\n"
      start
    end

    # Player Ship Placement
    puts "I have laid out my ships on the grid.\nYou now need to lay out your two ships.\nThe Cruiser is three units long and the Submarine is two units long."
    @board_player.render_board
    puts "Enter the 3 squares for the Cruiser, separated by spaces:"
    cruiser_coords_p1 = gets.strip.gsub(",", "").upcase.split(" ")
    binding.pry

    cruiser_p1 = Ship.new("Cruiser", 3)
    submarine_p1 = Ship.new("Submarine", 2)
    valid_placement = 0
    until valid_placement == 1
      if @board_player.valid_placement?(cruiser_p1, cruiser_coords_p1)
        @board_player.place(cruiser_p1, cruiser_coords_p1)
        valid_placement += 1
        @board_player.render_board
        binding.pry
      else
        puts "Your entered squares for Cruiser are invalid. Please try again and enter 3 squares for the Cruiser, separated by spaces (Example: A1 A2 A3):"
        cruiser_coords_p1 = gets.strip.gsub(",", "").upcase.split(" ")
      end
    end

    puts "Enter the 2 squares for the Submarine, separated by spaces"
    submarine_coords_p1 = gets.strip.gsub(",", "").upcase.split(" ")

    until valid_placement == 2
      if @board_player.valid_placement?(submarine_p1, submarine_coords_p1)
        @board_player.place(submarine_p1, submarine_coords_p1)
        valid_placement += 1
        @board_player.render_board
        binding.pry
      else
        puts "Your entered squares for Submarine are invalid. Please try again and enter 2 squares for the Submarine, separated by spaces (Example: A1 A2):"
        submarine_coords_p1 = gets.strip.gsub(",", "").upcase.split(" ")
    end


    until valid_placement == 2
      if @board_computer.valid_placement?(cruiser, @cruiser_coords)
        @board_computer.place(cruiser, @cruiser_coords)
        valid_placement += 1
        binding.pry
      else
        @cruiser_coords = computer_placement(cruiser)
        binding.pry
      end
    end



  end

  def computer_placement(ship)
    coordinates = []
    letters = ["A", "B", "C", "D"]
    nums = ["1", "2", "3", "4"]
    coordinates << letters.sample + nums.sample
    #["B2"], r1 = 0, ship.length = 2
    cell_index = 0
    r1 = [0, 1].sample
    until coordinates.count == ship.length
      if r1 == 0 && coordinates[cell_index][1..-1].to_i < 4
        num = coordinates[cell_index][1..-1].to_i + 1 # coordinates = ["B2"] num = 2 + 1 = 3
        coordinates << coordinates[cell_index][0] + num.to_s # "B" + "3" => "B3" coordinates = ["B2", "B3"]
        cell_index += 1
      elsif r1 == 0 && coordinates[cell_index][1..-1].to_i == 4
        coordinates.clear
        coordinates << letters.sample + nums.sample
        cell_index = 0
      elsif r1 == 1 && coordinates[cell_index][0] < "D"
        letter = coordinates[cell_index][0].ord + 1
        coordinates << letter.chr + coordinates[cell_index][1..-1].to_i.to_s
        cell_index += 1
      elsif r1 == 1 && coordinates[cell_index][0] == "D"
        coordinates.clear
        coordinates << letters.sample + nums.sample
        cell_index = 0
      else
        coordinates.clear
        coordinates << letters.sample + nums.sample
        cell_index = 0
      end
    end
    coordinates
  end
end
