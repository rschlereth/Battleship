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
    elsif @ship.length != @ship.health
      return true
    else
      return false
    end
   end

  def fire_upon
    # check if there's a ship present in the cell, if there is a ship in the cell, then there's a hit
    if empty? == false
      @ship.hit
    elsif
      @cell_hit += 1
    end
    #if no ship in cell, then miss
  end

  def render(trigger = false)
    if trigger == true
      if empty? == false
        return "S"
      end
    # if fired_upon_the_cell? is false, then it renders "."
    elsif fired_upon? == false
      return "."
    # if fired_upon? is true and no ship, then renders "M"
    elsif fired_upon? == true && empty? == true
      return "M"
    # if the cell has a ship, has been fired upon, AND the ship has sunk, then render "X"
  elsif fired_upon? == true && empty? == false && @ship.health == 0
    return "X"
    # if the cell has a ship and is fired upon, then it renders "H"
    elsif fired_upon? == true && empty? == false
      return "H"
    end
  end
end
