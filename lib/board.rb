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

  def compare_letters(cd1, cd2)
    cd1.ord - cd2.ord
  end

  def compare_numbers(cd1, cd2)
    cd1[1..-1].to_i - cd2[1..-1].to_i
  end

  def valid_placement?(ship, coordinates)
    valid_pair = 0
    # testing to see if the ship length is the same as the number of cells
    if ship.length != coordinates.count
      return false
    elsif
      coordinates.each_cons(2) do |cd1, cd2|
        if compare_letters(cd1, cd2) != 0 && compare_letters(cd1, cd2) != -1
          return false
        elsif compare_letters(cd1, cd2) == -1 && compare_numbers(cd1, cd2) != 0
          return false
        elsif compare_letters(cd1, cd2) == 0 && compare_numbers(cd1, cd2) != -1
          return false
        else
          valid_pair += 1
        end
      end
    else
      coordinates.each do |coordinate|
        if @cells[coordinate].empty? == false
          return false
        end
      end
    end
    true if valid_pair == coordinates.count - 1
  end

  def place(ship, coordinates)
    # take each coordinate and place a ship in them
    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  def render_board(trigger = false)
    # p "  1 2 3 4 \n"
    letters = ["A", "B", "C", "D"]
    nums = [1, 2, 3, 4]
    board_render = "  1 2 3 4 \n"
    letters.each do |letter|
      board_render += letter
      board_render += " "
      nums.each do |num|
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
