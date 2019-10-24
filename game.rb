# require 'awesome_print'

require_relative './piece.rb'
Dir["./pieces/*.rb"].each {|file| require file }
require_relative './board.rb'
require_relative './helpers.rb'

class Game
  attr_accessor :board

  def initialize(placements = {})
    @board = Board.new(placements)
  end

end

game = Game.new
board = game.board
board.new_game!
# board.new_game!
board.display
