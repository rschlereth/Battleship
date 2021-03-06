class Board
  attr_reader :cells, :name

  def initialize
    @cells = {
      "A1" => Cell.new("A1"),
      "A2" => Cell.new("A2"),
      "A3" => Cell.new("A3"),
      "A4" => Cell.new("A4"),
      "B1" => Cell.new("B1"),
      "B2" => Cell.new("B2"),
      "B3" => Cell.new("B3"),
      "B4" => Cell.new("B4"),
      "C1" => Cell.new("C1"),
      "C2" => Cell.new("C2"),
      "C3" => Cell.new("C3"),
      "C4" => Cell.new("C4"),
      "D1" => Cell.new("D1"),
      "D2" => Cell.new("D2"),
      "D3" => Cell.new("D3"),
      "D4" => Cell.new("D4")
    }
  end

  def valid_coordinate?(coordinate)
    @cells.key?(coordinate)
  end

  # helper method to valid_placement? method
  def no_overlapping_ships?(coordinates)
    coordinates.each do |coordinate|
      if !@cells[coordinate].empty?
        return false
      end
    end
  end

  # helper method to valid_coordinate_pairs method
  def compare_letters(cd1, cd2)
    cd1.ord - cd2.ord
  end

  # helper method to valid_coordinate_pairs method
  def compare_numbers(cd1, cd2)
    cd1[1..-1].to_i - cd2[1..-1].to_i
  end

  # helper method to valid_placement? method
  def valid_coordinate_pairs(coordinates)
    coordinates.each_cons(2) do |cd1, cd2|
      if compare_letters(cd1, cd2) != 0 && compare_letters(cd1, cd2) != -1
        return false
      elsif compare_letters(cd1, cd2) == -1 && compare_numbers(cd1, cd2) != 0
        return false
      elsif compare_letters(cd1, cd2) == 0 && compare_numbers(cd1, cd2) != -1
        return false
      else
        @valid_pair += 1
      end
    end
  end

  def valid_coordinates?(coordinates)
    coordinates.each do |coordinate|
      if !valid_coordinate?(coordinate)
        return false
      end
    end
  end

  def valid_placement?(ship, coordinates)
    @valid_pair = 0
    # testing to see if the ship length is the same as the number of cells
    if ship.length != coordinates.count || !valid_coordinates?(coordinates)
      return false
    else
      valid_coordinate_pairs(coordinates)
      if @valid_pair == coordinates.count - 1 && no_overlapping_ships?(coordinates)
        return true
      else
        return false
      end
    end
  end

  def place(ship, coordinates)
    # take each coordinate and place a ship in them
    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  # helper method for render_board method
  def generate_letters(height)
    @board_letters = []
    letter_ord = 65
    until @board_letters.count == height
      @board_letters << letter_ord.chr
      letter_ord += 1
    end
  end

  # helper method for render_board method
  def generate_numbers(width)
    @board_numbers = []
    number = 1
    until @board_numbers.count == width
      @board_numbers << number.to_s
      number += 1
    end
  end

  def render_board(height = 4, width = 4, trigger = false)
    generate_letters(height)
    generate_numbers(width)

    # board_render = "  1 2 3 4 \n" # add "A"
    board_render = "  "
    @board_numbers.each do |number|
      board_render += number + " "
    end
    board_render += "\n"
    @board_letters.each do |letter| # "A"
      board_render += letter # board_render = "  \ 1 2 3 4 \nA"
      board_render += " " # board_render = "  \ 1 2 3 4 \nA "
      @board_numbers.each do |num| # num = 1
        # @cells["A" + "1" = "A1"].render_cell(trigger = false)
        # @cells["A1"].render_cell
        board_render += @cells[letter + num.to_s].render_cell(trigger)
        board_render += " "
      end
      board_render += "\n"
    end
    p board_render
    # p board_render[0,12]
    # p board_render[11,11]
    # p board_render[22,11]
    # p board_render[33,11]
    # p board_render[44,11]
  end

end
