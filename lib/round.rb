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
      exit
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
        else
          @submarine_coords_c = computer_placement(submarine_c)
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

    cruiser_p1 = Ship.new("Cruiser", 3)
    submarine_p1 = Ship.new("Submarine", 2)
    valid_placement = 0
    until valid_placement == 1
      if @board_player.valid_placement?(cruiser_p1, cruiser_coords_p1)
        @board_player.place(cruiser_p1, cruiser_coords_p1)
        valid_placement += 1
        @board_player.render_board(true)
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
        @board_player.render_board(true)
      else
        puts "Your entered squares for Submarine are invalid. Please try again and enter 2 squares for the Submarine, separated by spaces (Example: A1 A2):"
        submarine_coords_p1 = gets.strip.gsub(",", "").upcase.split(" ")
      end
    end

    # Displaying the Boards
    puts "=============COMPUTER BOARD=============\n"
    @board_computer.render_board
    puts "==============PLAYER BOARD==============\n"
    @board_player.render_board(true)

    hits_by_player = 0
    hits_by_computer = 0
    until hits_by_player == 5 || hits_by_computer == 5

      # Player guesses square
      puts "Enter the square for your shot:"
      player_guess = gets.strip.gsub(",", "").upcase
      guess_counter = 0
      until guess_counter == 1
        # create a check for if the cell has already been guessed
        # looking to see if @cell_hit of the player_guess cell has a counter that is greater than 0 (if it's >0, it's been hit)
        if @board_computer.cells[player_guess].cell_hit > 0
          puts "Square has been guessed already. Please select again:"
          player_guess = gets.strip.gsub(",", "").upcase
        elsif @board_computer.valid_coordinate?(player_guess)
          guess_counter += 1
        else
          puts "Please enter a valid coordinate:"
          player_guess = gets.strip.gsub(",", "").upcase
        end
      end

      # Computer guesses square
      # hash.keys => [array of keys].sample
      computer_guess = @board_player.cells.keys.sample
      @board_player.cells.keys - [computer_guess]

    # Diplay Results
    # To do:
      # Shoot at cell for both player and computer
        # board.cells["A1"] --> access to Cell A1 and all the Cell methods
        # board.cells[key] => Cell.new("key")
      @board_computer.cells[player_guess].fire_upon
      @board_player.cells[computer_guess].fire_upon

    # Tell player the outcome of both shots
      # Your shot on A4 was a miss.
      # My shot on C1 was a miss.
      # .render_cell => "H", "M", "X"

      # Player guess outcome
      if @board_computer.cells[player_guess].render_cell == "H"
        puts "Your shot on #{player_guess} hit a ship."
        hits_by_player += 1
      elsif @board_computer.cells[player_guess].render_cell == "M"
        puts "Your shot on #{player_guess} was a miss."
      elsif @board_computer.cells[player_guess].render_cell == "X"
        hits_by_player += 1
        if @board_computer.cells[player_guess].ship.length == 2
          puts "Your shot on #{player_guess} hit a ship. You sank my submarine!"
        elsif @board_computer.cells[player_guess].ship.length == 3
          puts "Your shot on #{player_guess} hit a ship. You sank my cruiser!"
        else
          puts "Your shot on #{player_guess} hit a ship. You sank my ship!"
        end
      end

      # Computer guess outcome
      if @board_player.cells[computer_guess].render_cell == "H"
        puts "My shot on #{computer_guess} hit a ship."
        hits_by_computer += 1
      elsif @board_player.cells[computer_guess].render_cell == "M"
        puts "My shot on #{computer_guess} was a miss."
      elsif @board_player.cells[computer_guess].render_cell == "X"
        hits_by_computer += 1
        if @board_player.cells[computer_guess].ship.length == 2
          puts "My shot on #{computer_guess} hit a ship. I sank your submarine!"
        elsif @board_player.cells[computer_guess].ship.length == 3
          puts "My shot on #{computer_guess} hit a ship. I sank your cruiser!"
        else
          puts "My shot on #{computer_guess} hit a ship. I sank your ship!"
        end
      end

      # Displaying the Boards
      puts "=============COMPUTER BOARD=============\n"
      @board_computer.render_board
      "\n"
      puts "==============PLAYER BOARD==============\n"
      @board_player.render_board(true)
      "\n"
    end

    # if player hits = 5, then puts "You won"
    # if computer hits = 5, then puts "I won"
    if hits_by_player == 5
      puts "You won :("
    elsif hits_by_computer == 5
      puts "I won!"
    end

    start
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
