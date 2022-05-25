require './lib/round'
require './lib/board'
require './lib/cell'
require './lib/ship'
require 'pry'

RSpec.describe Round do
  before(:each) do
    @board_computer = Board.new
    @board_player = Board.new
    @round = Round.new(@board_computer, @board_player)
  end

  it "runs without user input" do
    expect(@round.start("q", 5, 4)).to eq(true)
  end

  it "creates boards of different dimensions" do
    @round.start("p", 5, 4)
    expect(@board_computer.cells.keys.count).to eq(20)
    expect(@board_computer.cells.keys[-1]).to eq("E4")
  end

  it "renders boards of different dimensions" do
    @round.start("p", 5, 6)
    cruiser = Ship.new("Cruiser", 3)
    @board_player.place(cruiser,["E1", "E2", "E3"])

    expect(@board_player.render_board(5, 6)).to eq(
      "  1 2 3 4 5 6 \n" +
      "A . . . . . . \n" +
      "B . . . . . . \n" +
      "C . . . . . . \n" +
      "D . . . . . . \n" +
      "E . . . . . . \n"
      )
    expect(@board_player.render_board(5, 6, true)).to eq(
      "  1 2 3 4 5 6 \n" +
      "A . . . . . . \n" +
      "B . . . . . . \n" +
      "C . . . . . . \n" +
      "D . . . . . . \n" +
      "E S S S . . . \n"
      )
    end

  it "has computer make consecutive guesses" do
    @round.start("p", 5, 6)
    p1_cruiser = Ship.new("Cruiser", 3)
    p1_submarine = Ship.new("Submarine", 2)
    @board_player.place(p1_cruiser, ["C2", "C3", "C4"])
    @board_player.place(p1_submarine, ["D6", "E6"])

    expect(@round.intelligent_guesses("C2", 5, 6)).to eq("C3")
    expect(@round.intelligent_guesses("E6", 5, 6)).to eq("E5")
  end
end
