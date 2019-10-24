module BoardHelper
  def self.index_alias_for(term)
    return {
      "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7
    }[term]
  end

  def self.letter_to_piece(term, color, location)
    return {
      "p" => Pawn.new(color, location),
      "r" => Rook.new(color, location),
      "h" => Knight.new(color, location),
      "b" => Bishop.new(color, location),
      "k" => King.new(color, location),
      "q" => Queen.new(color, location)
    }[term]
  end

  def self.initial_piece_locations
    return {
      pawn: {
        white: ("a".."h").to_a.map {|l| l+"2" },
        black: ("a".."h").to_a.map {|l| l+"7" }
      },
      rook: {
        white: ["a1", "h1"],
        black: ["a8", "h8"]
      },
      knight: {
        white: ["b1", "g1"],
        black: ["b8", "g8"]
      },
      bishop: {
        white: ["c1", "f1"],
        black: ["c8", "f8"]
        
      },
      queen: {
        white: ["e1"],
        black: ["e8"]
      },
      king: {
        white: ["d1"],
        black: ["d8"]
      }
    }
  end
end