class Round

  def initialize(board_computer, board_player)
    @board_computer = board_computer
    @board_player = board_player
  end

  def start(p_or_q = nil, height = 4, width = 4)
    if p_or_q == "q"
      true
    elsif p_or_q == "p"
      dimensions(height, width)
      @board_player.render_board(height, width)
    else
      user_input_version
    end
  end

  def dimensions(height, width)
    @board_computer.cells.clear
    @board_player.cells.clear

    @board_letters = []
    letter_ord = 65
    until @board_letters.count == height
      @board_letters << letter_ord.chr
      letter_ord += 1
    end

    @board_numbers = []
    number = 1
    until @board_numbers.count == width
      @board_numbers << number.to_s
      number += 1
    end

    cells_key = []
    @board_letters.each do |letter|
      @board_numbers.each do |number|
        cells_key << letter + number
      end
    end

    cells_key.each do |key|
      @board_computer.cells[key] = Cell.new(key)
      @board_player.cells[key] = Cell.new(key)
    end
  end

  # RSpec version for testing
  def intelligent_guesses(first_guess, height, width)
    players_board_cells = @board_player.cells.keys
    hits_by_computer = 0
    computer_guess = first_guess
    players_board_cells -= [computer_guess]
    @board_player.cells[computer_guess].fire_upon

    # until hits_by_computer == 5
      until @board_player.cells[computer_guess].render_cell == "H"
        computer_guess = @board_player.cells.keys.sample
        players_board_cells -= [computer_guess]
        return computer_guess
      end

      direction = "right"
      until players_board_cells.include?(computer_guess) == true
        if direction == "right" && computer_guess[-1..1].to_i < width
          next_guess_num = computer_guess[1..-1].to_i + 1 # from 2 to 3
          computer_guess = computer_guess[0] + next_guess_num.to_s # "C3"
          return computer_guess
        elsif direction == "right" && computer_guess[-1..1].to_i == width
          direction = "left"
        elsif direction == "left" && computer_guess[-1..1].to_i > 1
          next_guess_num = computer_guess[1..-1].to_i - 1 # from 2 to 1
          computer_guess = computer_guess[0] + next_guess_num.to_s # "C1"
          return computer_guess
        elsif direction == 1 && computer_guess[1..-1].to_i == 1
          direction = "up"
        elsif direction == "up" && computer_guess[0] > "A"
          next_guess_letter = computer_guess[0].ord - 1
          computer_guess = next_guess_letter.chr + computer_guess[1..-1]
          return computer_guess
        elsif direction == "up" && computer_guess[0] == "A"
          direction = "down"
        elsif direction == "down" && computer_guess[0].ord - 64 < height
          next_guess_letter = computer_guess[0].ord + 1
          computer_guess = next_guess_letter.chr + computer_guess[1..-1]
          return computer_guess
        end
        players_board_cells -= [computer_guess]
      end
    end

  def user_input_version
    puts "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit."
    start_button = gets.strip
    if start_button.downcase == "q"
      puts "See you next time!"
      true
      exit
    # Computer Ship Placement
    elsif start_button.downcase == "p"
      puts "Select your board dimensions. Please enter the number of rows for height and number of columns for width, separated by a space."
      dimensions_counter = 0
      until dimensions_counter == 1
        dimensions = gets.strip.gsub(",", "").split(" ")
        submarine_c = Ship.new("Submarine", 2)
        cruiser_c = Ship.new("Cruiser", 3)
        height = dimensions[0].to_i
        width = dimensions[-1].to_i
        if height <= 26 && width <= 26 && height * width > submarine_c.length + cruiser_c.length
          dimensions(height, width)
          dimensions_counter += 1
        else
          puts "Incorrect height or width dimensions. Height and width need to be entered as integers; the height and width cannot each be greater than 26; and the board should be large enough to accommodate your ships. Example: 4 4. Please try again."
        end
      end

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
    puts "I have laid out my ships on the grid.\nYou now need to lay out your two ships.\nThe Cruiser is three units long and the Submarine is two units long.\n"
    @board_player.render_board(height, width)
    puts "Enter the 3 squares for the Cruiser, separated by spaces:"
    cruiser_coords_p1 = gets.strip.gsub(",", "").upcase.split(" ")

    cruiser_p1 = Ship.new("Cruiser", 3)
    submarine_p1 = Ship.new("Submarine", 2)
    valid_placement = 0
    until valid_placement == 1
      if @board_player.valid_placement?(cruiser_p1, cruiser_coords_p1)
        @board_player.place(cruiser_p1, cruiser_coords_p1)
        valid_placement += 1
        @board_player.render_board(height, width, true)
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
        @board_player.render_board(height, width, true)
      else
        puts "Your entered squares for Submarine are invalid. Please try again and enter 2 squares for the Submarine, separated by spaces (Example: A1 A2):"
        @board_player.render_board(height, width, true)
        submarine_coords_p1 = gets.strip.gsub(",", "").upcase.split(" ")
      end
    end

    # Displaying the Boards
    puts "=============COMPUTER BOARD=============\n"
    @board_computer.render_board(height, width)
    puts "\n"
    puts "==============PLAYER BOARD==============\n"
    @board_player.render_board(height, width, true)

    hits_by_player = 0
    hits_by_computer = 0
    individual_ship_hit = 0
    players_board_cells = @board_player.cells.keys
    until hits_by_player == 5 || hits_by_computer == 5

      # Player guesses square
      puts "Enter the square for your shot:"
      player_guess = gets.strip.gsub(",", "").upcase
      guess_counter = 0
      until guess_counter == 1
        # create a check for if the cell has already been guessed
        # looking to see if @cell_hit of the player_guess cell has a counter that is greater than 0 (if it's >0, it's been hit)
        if !@board_computer.valid_coordinate?(player_guess) || @board_computer.cells[player_guess].cell_hit > 0
          puts "Square has been guessed already or is not a valid square. Please select again:"
          player_guess = gets.strip.gsub(",", "").upcase
        elsif @board_computer.valid_coordinate?(player_guess)
          guess_counter += 1
        else
          puts "Please enter a valid coordinate:"
          player_guess = gets.strip.gsub(",", "").upcase
        end
      end

      # computer guess
      # generate random guesses for squares
      if hits_by_computer == 0 || @computer_guess_result == "X" || individual_ship_hit == 0
        computer_guess = players_board_cells.sample
        players_board_cells -= [computer_guess]
        direction = "right"
      else
        until players_board_cells.include?(computer_guess) == true
          if @computer_guess_result == "H" && direction == "right" && computer_guess[-1..1].to_i < width # made first hit, need to check all 4 sides
            next_guess_num = computer_guess[1..-1].to_i + 1 # from 2 to 3
            computer_guess = computer_guess[0] + next_guess_num.to_s # "C3"
          elsif @computer_guess_result == "H" && direction == "right" && computer_guess[-1..1].to_i == width # last hit was an H; moving right; but at edge of board
            direction = "left"
            next_guess_num = computer_guess[1..-1].to_i - individual_ship_hit  # from 2 to 1
            computer_guess = computer_guess[0] + next_guess_num.to_s #"C1"
          elsif @computer_guess_result == "M" && direction == "right"
            direction = "left"
            next_guess_num = computer_guess[1..-1].to_i - (individual_ship_hit + 1)# from 2 to 1
            computer_guess = computer_guess[0] + next_guess_num.to_s #"C1"
          elsif @computer_guess_result == "H" && direction == "left" && computer_guess[-1..1].to_i > 1
            next_guess_num = computer_guess[1..-1].to_i - 1 # from 2 to 1
            computer_guess = computer_guess[0] + next_guess_num.to_s #"C1"
          elsif @computer_guess_result == "M" && direction == "left" && computer_guess[0] > "A"
            direction = "up"
            next_guess_num = computer_guess[1..-1].to_i + 1 # C4H, C5M, C3M, B4
            next_guess_letter = computer_guess[0].ord - 1 # C.ord = 67; 67-1 = 66
            computer_guess = next_guess_letter.chr + next_guess_num.to_s # B4
          elsif @computer_guess_result == "H" && direction == "up" && computer_guess[0] > "A"
            next_guess_letter = computer_guess[0].ord - 1 # C.ord = 67; 67-1 = 66
            computer_guess = next_guess_letter.chr + computer_guess[1..-1]
          elsif @computer_guess_result == "H" && direction == "up" && computer_guess[0] == "A"
            direction = "down"
            next_guess_letter = computer_guess[0].ord + individual_ship_hit # "A".ord = 65; 65+2 = 67 => "C"
            computer_guess = next_guess_letter.chr + computer_guess[1..-1]
          elsif @computer_guess_result == "M" && direction == "up" && computer_guess[0].ord - "A".ord + 1 < height
            direction = "down"
            next_guess_letter = computer_guess[0].ord + (individual_ship_hit + 1) # B.ord = 66; 66+3 = 69
            computer_guess = next_guess_letter.chr + computer_guess[1..-1]
          elsif @computer_guess_result == "H" && direction == "down" && computer_guess[0].ord - "A".ord + 1 < height
            next_guess_letter = computer_guess[0].ord + 1 # C.ord = 67; 67-1 = 66
            computer_guess = next_guess_letter.chr + computer_guess[1..-1]
          else
            computer_guess = players_board_cells.sample
            players_board_cells -= [computer_guess]
            direction = "right"
          end
        end
        players_board_cells -= [computer_guess]
      end

      # fire upon the selected cells
      @board_computer.cells[player_guess].fire_upon
      @board_player.cells[computer_guess].fire_upon

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

      # adjust variables for intelligent guesses based on outcome
      @computer_guess_result = @board_player.cells[computer_guess].render_cell
      if @computer_guess_result == "X"
        individual_ship_hit = 0
      elsif @computer_guess_result == "H"
        individual_ship_hit += 1
      end

      # Displaying the Boards
      puts "\n=============COMPUTER BOARD=============\n"
      @board_computer.render_board(height, width)
      puts "\n"
      puts "==============PLAYER BOARD==============\n"
      @board_player.render_board(height, width, true)
      puts "\n"
    end

    # if player hits = 5, then puts "You won"
    # if computer hits = 5, then puts "I won"
    if hits_by_player == 5
      puts "You won :(\n"
    elsif hits_by_computer == 5
      puts "I won!\n"
      puts "\n"
    end

    start
  end

  def computer_placement(ship)
    coordinates = []
    # method edited for iteration 4
    # letters = ["A", "B", "C", "D"]
    # nums = ["1", "2", "3", "4"]
    coordinates << @board_letters.sample + @board_numbers.sample
    #["B2"], random_num = 0, ship.length = 2
    cell_index = 0
    random_num = [0, 1].sample
    until coordinates.count == ship.length
      if random_num == 0 && coordinates[cell_index][1..-1].to_i < @board_numbers[-1].to_i
        num = coordinates[cell_index][1..-1].to_i + 1 # coordinates = ["B2"] num = 2 + 1 = 3
        coordinates << coordinates[cell_index][0] + num.to_s # "B" + "3" => "B3" coordinates = ["B2", "B3"]
        cell_index += 1
      elsif random_num == 0 && coordinates[cell_index][1..-1].to_i == @board_numbers[-1].to_i
        coordinates.clear
        coordinates << @board_letters.sample + @board_numbers.sample
        cell_index = 0
      elsif random_num == 1 && coordinates[cell_index][0] < @board_letters[-1]
        letter = coordinates[cell_index][0].ord + 1
        coordinates << letter.chr + coordinates[cell_index][1..-1].to_i.to_s
        cell_index += 1
      elsif random_num == 1 && coordinates[cell_index][0] == @board_letters[-1]
        coordinates.clear
        coordinates << @board_letters.sample + @board_numbers.sample
        cell_index = 0
      else
        coordinates.clear
        coordinates << @board_letters.sample + @board_numbers.sample
        cell_index = 0
      end
    end
    coordinates
  end
end
