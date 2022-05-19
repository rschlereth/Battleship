require './lib/board'
require './lib/cell'
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
end
