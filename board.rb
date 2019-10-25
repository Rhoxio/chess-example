class Board
  def initialize(placements = nil)
    @data = Array.new(8){Array.new(8)}
    clear_and_set!

    if placements
      # If you want to place custom pieces on initialization, write some code to do just that.
      # You should be able to figure out a way to get a pre-fabricated array of data set to @data like George suggested you do.
      # 
      # Maybe just set @data to something? Pass an argument?
      # 
      # You could also pass in an array of Piece objects, look at their locations, and #place! them individually.
    end
  end

  # ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #
  # !! IMPORTANT !!
  # Note the method #indexes_at pulls indexes for the REVERSED VERSION OF THE @data ARRAY. (i.e. @data.reverse)
  # We do this because it is easier to simply reverse the array and insert based on the tile data given to us as an argument.
  # This also makes it so we can set the strings for 'empty' spaces as nil values if we want to without it causing side-effects.
  # 
  # This circumvents having to check each element in the nested array when all we want to do is insert something. The size,
  # layout, and ordering of the board stays consistent, which also allows us to do this without having to worry about edge-cases. 
  # 
  # Due to how we expect the board to be displayed (in browser and console) as: 
  #   x (letters) on bottom, y (numbers) on left  
  #   (BEFORE @data.reverse is called - display mode)
  #   _
  #   
  #    |       h8
  #    |
  #    |
  #   y|a1_______
  #     x (letters)
  # 
  # as opposed to like this in a 2D array representation
  #   x (letters) on top, y on left
  #   (AFTER @data.reverse is called - 2D array mode)
  #   _
  #   
  #   x indexes (letters)
  #    ________
  #  y|a1
  #   |
  #   |
  #   |      h8

  # We just have to 'pivot' on the x axis to transform it back and forth visually and structurally. 
  # 
  # It is easier to treat the array as if it has a 'pivot point' at
  # the top of it that allows us to translate our visual representation into a 'code' representation.
  # 
  # The method #place! automatically does this flip-flop for us using reversed_data and calling reversed_data.reverse
  # after it is done appending the correct objects. 
  # 
  # "I wrote something ths code but my data is backwards...?"
  # 
  # "Look at #place!, then look at the graphic above. You need to reverse @data BEFORE you 
  # insert at an index because we have it in a kind of semantic 'display mode'
  # by default, and reversing (@data.reverse) switches it from 'display mode' to '2d array mode', 
  # then back again if you call #reverse one more time."
  # 
  # ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #

  def indexes_at(tile)
    tile = tile.downcase

    # Splitting into ["a", "1"] if tile is "a1"
    chunks = tile.split("")

    # The number given to us is always going to be 1 less than the index we need to target on the y axis.
    y = chunks[1].to_i - 1

    # Check out helpers.rb. All this method does is translate a letter into the corresponding index value.
    x = BoardHelper.index_alias_for(chunks[0])   
    return [y, x]
  end

  def place!(piece, tile)
    # Find the index in @data where the piece needs to be placed...
    indexes = indexes_at(tile)

    # Assigning simple variables to y and x for clarity...
    y, x = indexes[0], indexes[1]

    # Remember the important comment above? Read it again if you don't understand why we are reversing here. :)
    # reversed_data is NOT setting @data here. 
    reversed_data = @data.reverse

    # Insert data at the coordinates specificed...
    reversed_data[y][x] = piece

    # Reversing the 'reversed_data' back to normal and setting it to @data for display and consumption elsewhere.
    @data = reversed_data.reverse
  end  

  def clear_and_set!
    # 'scaffold' is representative of an 8 x 8 board full of nil values. This is our starting point. 
    scaffold = Array.new(8){Array.new(8)}

    # Makes an array from a - h in the English alphabet. 
    labels = ("a".."h").to_a

    # Nested traversal
    scaffold.each_with_index do |set, parent_index|
      # 'set' is the current row in our 2D array 'scaffold'
      # if 'parent_index' is 0, 'set' would need to be: ['a8', 'b8', 'c8', 'd8', 'e8', 'f8', 'h8']
      set.each_with_index do |tile, child_index|
        
        # Looks at 'labels' for the current parent index (0-7 -> a..h) and pulls the 
        # label corresponding to the index and adds 1 to the current child_index (0-7) to give a string
        # back with the correct x axis tile label. i.e. 'a', 'd', 'h'
        label = labels[parent_index]

        # Setting the element to contain the string created in label + the corresponding y value
        # e.x. set[child_index] = "a1"
        set[child_index] = "#{label}#{child_index+1}"
      end
    end
    # We did this in order alphabetically and numerically from top to bottom, so 
    # transposing and reversing puts @data in the correct 'visual' format for us.
    @data = scaffold.transpose.reverse
  end

  def new_game!
    # Clearing the board...
    clear_and_set!

    # Grabs the initial locations and name/type formatting from our helper...
    # The helper in in helpers.rb. It's a hash structure that allows us to 
    # use the names of keys to delegate what conditions we want the code to run under.
    pieces = BoardHelper.initial_piece_locations
    pieces.each do |piece, colors|

      # Translates the key (piece) passed in the block above from :pawn to "Pawn", :rook to "Rook", etc. 
      # so we can call it by class name below.
      piece_name = piece.to_s.capitalize

      colors.each do |color, locations|
        # 'color' is the key inside of the piece hash. (i.e. :white or :black)
        # 'locations' is the array used to hold the String representations of where the pieces should go. (i.e. ['a1', 'd8'])
        locations.each do |tile|
          # Welcome to metaprogramming. This line of code takes the string we constructed above
          # of "Pawn" or "Rook" or another piece's class name, calls the Kernel and asks for a constant (in this case a class)
          # called whatever the string corresponds to.

          # 'Kernel.const_get("Pawn").new' would be essentially the same code as 'Pawn.new'.
          # Pass it color data as a String and the tile ('a1' or whatever) for its location...
          piece = Kernel.const_get(piece_name).new(color.to_s, tile)

          # Place it on the board. 
          place!(piece, tile)
        end
      end

    end
  end

  def display
    @data.each do |square|
      p square
      puts "\n"
    end
  end

end