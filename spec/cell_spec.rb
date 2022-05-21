require './lib/ship'
require './lib/cell'
require "pry"

RSpec.describe Cell do
  before(:each) do
    @cell = Cell.new("B4")
  end

  it "creates a Cell" do
    expect(@cell).to be_instance_of(Cell)
  end

  it "has a coordinate" do
    expect(@cell.coordinate).to eq("B4")
  end

  it "does not have a ship by default" do
    expect(@cell.ship).to eq(nil)
  end

  it "is an empty cell" do
    expect(@cell.empty?).to eq(true)
  end

  it "can create a ship" do
    cruiser = Ship.new("Cruiser", 3)
    expect(cruiser).to be_instance_of(Ship)
  end

  it "can place a ship on cells" do
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)
    expect(@cell.ship).to be_instance_of(Ship)
    expect(@cell.empty?).to eq(false)
  end

  it "has not been fired upon by default" do
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)
    expect(@cell.fired_upon?).to eq(false)
  end

  it "has been fired upon" do
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)
    @cell.fire_upon
    expect(@cell.ship.health).to eq(2)
    expect(@cell.fired_upon?).to eq(true)
  end

  it "renders a period if not fired upon" do
    expect(@cell.render_cell).to eq(".")
  end

  it "renders a letter M if fired upon but does not contain a ship" do
    @cell.fire_upon
    expect(@cell.render_cell).to eq("M")
  end

  it "shows a ship" do
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)
    expect(@cell.render_cell).to eq(".")
    expect(@cell.render_cell(true)).to eq("S")
  end

  it "shows a hit" do
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)
    @cell.fire_upon
    expect(@cell.render_cell).to eq("H")
    expect(cruiser.sunk?).to eq(false)
  end

  it "shows a ship" do
    cruiser = Ship.new("Cruiser", 3)
    @cell.place_ship(cruiser)
    @cell.fire_upon
    2.times do cruiser.hit end
    expect(cruiser.sunk?).to eq(true)
    expect(@cell.render_cell).to eq("X")
  end
end
