class Cell
  attr_reader :coordinate, :cell_hit
  attr_accessor :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @cell_hit = 0
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship_instance)
    @ship = ship_instance
  end

  def fired_upon?
    # if the cell IS empty
    if empty? == true
      if @cell_hit > 0
        return true
      else
        return false
      end
    # if the cell is not empty (has a ship)
    elsif @cell_hit > 0
      # @ship.length = 2; @ship.health = 1
      # A1 and A2 hosts submarine
      # submarine length of 2; and health of 2
      # A1 gets hit
      # submarine has a length 2; health is down to 1
      # A2's status -- has it been fired_upon?
      # Answers yes even though A2 has NOT been fired upon!!
      return true
    else
      return false
    end
   end

  def fire_upon
    # check if there's a ship present in the cell, if there is a ship in the cell, then there's a hit
    if empty? == false
      @ship.hit
      @cell_hit += 1
    elsif
      @cell_hit += 1
    end
    #if no ship in cell, then miss
  end

  def render_cell(trigger = false)
    if trigger == true && empty? == false
      if fired_upon? == true
        if @ship.sunk? == true
          return "X"
        else
          return "H"
        end
      else
        return "S"
      end
    # if fired_upon_the_cell? is false, then it renders "."
    elsif fired_upon? == false
      return "."
    # if fired_upon? is true and no ship, then renders "M"
    elsif fired_upon? == true && empty? == true
      return "M"
    # if the cell has a ship, has been fired upon, AND the ship has sunk, then render "X"
    elsif fired_upon? == true && empty? == false && @ship.sunk? == true
      return "X"
    # if the cell has a ship and is fired upon, then it renders "H"
    elsif fired_upon? == true && empty? == false
      return "H"
    end
  end
end
