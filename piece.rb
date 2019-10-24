class Piece

  attr_accessor :color, :location

  def initialize(color, location = nil)
    raise ArgumentError, "Please provide a piece color of either 'black' or 'white': #{color} " if !["black", "white"].include?(color)
    @color = color
    @location = location
  end

end