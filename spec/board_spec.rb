require './lib/board'
require './lib/cell'
require './lib/ship'
require 'pry'

RSpec.describe Board do
  before(:each) do
    @board = Board.new
  end

  it "has a board" do
    expect(@board).to be_an_instance_of(Board)
  end

  it "has cells" do
    expect(@board.cells.class).to eq(Hash)
    expect(@board.cells.count).to eq(16)
    expect(@board.cells["A2"]).to be_an_instance_of(Cell)
  end

  it "has valid coordinates" do
    expect(@board.valid_coordinate?("A1")).to eq(true)
    expect(@board.valid_coordinate?("D4")).to eq(true)
    expect(@board.valid_coordinate?("A5")).to eq(false)
    expect(@board.valid_coordinate?("E1")).to eq(false)
    expect(@board.valid_coordinate?("A22")).to eq(false)
  end

  it "has coordinates to equal ship length" do
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    expect(@board.valid_placement?(cruiser,["A1", "A2"])).to equal(false)
    expect(@board.valid_placement?(submarine, ["A2", "A3", "A4"])).to equal(false)
  end

  it "has consecutive coordinates" do
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    expect(@board.valid_placement?(cruiser, ["A1", "A2", "A4"])).to equal(false)
    expect(@board.valid_placement?(submarine, ["A1", "C1"])).to equal(false)
    expect(@board.valid_placement?(cruiser, ["A3", "A2", "A1"])).to equal(false)
    expect(@board.valid_placement?(submarine, ["C1", "B1"])).to equal(false)
  end

  it "has coordinates that can't be diagonal" do
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    expect(@board.valid_placement?(cruiser, ["A1", "B2", "C3"])).to equal(false)
    expect(@board.valid_placement?(submarine, ["C2", "D3"])).to equal(false)
  end

  it "has a valid placement" do
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    expect(@board.valid_placement?(submarine, ["A1", "A2"])).to equal(true)
    expect(@board.valid_placement?(cruiser, ["B1", "C1", "D1"])).to equal(true)
  end

  it "can place ships" do
    cruiser = Ship.new("Cruiser", 3)
    @board.place(cruiser, ["A1", "A2", "A3"])
    cell_1 = board.cells["A1"]
    cell_2 = board.cells["A2"]
    cell_3 = board.cells["A3"]

    expect(cell_1).to be_instance_of(Cell)
    expect(cell_2).to be_instance_of(Cell)
    expect(cell_3).to be_instance_of(Cell)
    expect(cell_1.ship).to be_instance_of(Ship)
    expect(cell_2.ship).to be_instance_of(Ship)
    expect(cell_3.ship).to be_instance_of(Ship)
    expect(cell_3.ship).to equal(cell_2.ship)
  end
end
