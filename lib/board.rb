class Board
  attr_reader :cells

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
      coordinates.each do |coordinate|
        if @cells[coordinate].empty? != true
          return false
        binding.pry
        end
      end
    else
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
    end
    true if valid_pair == coordinates.count - 1
  end

  def place(ship, coordinates)
    # take each coordinate and place a ship in them
    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

end
