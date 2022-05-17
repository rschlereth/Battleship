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
end
