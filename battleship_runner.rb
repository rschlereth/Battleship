require './lib/board'
require './lib/cell'
require './lib/ship'
require './lib/round'
require 'pry'

board_computer = Board.new
board_player = Board.new

round = Round.new(board_computer, board_player)
round.start

# round.computer_placement(Ship.new("Submarine", 2))
# round.computer_placement(Ship.new("Cruiser", 3))
