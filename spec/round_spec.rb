require './lib/round'
require './lib/board'
require './lib/cell'
require './lib/ship'
require 'pry'

RSpec.describe Round do
  before(:each) do
    board_computer = Board.new
    board_player = Board.new
    @round = Round.new(board_computer, board_player)
  end

  it "runs without user input" do
    expect(@round.start("q", 5, 4)).to eq(true)
  end

  it "creates boards of different dimensions" do
    @round.start("p", 5, 4)
    expect(board_computer.cells.keys.count).to eq(20)
    expect(board_computer.cells.keys[-1]).to eq("E4")


  end
end
