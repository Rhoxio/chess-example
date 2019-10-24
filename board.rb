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
  # !! Important !!
  # Note the method #indexes_at pulls indexes for the REVERSED VERSION OF THE @data ARRAY. i.e. @data.reverse
  # We do this because it is easier to simply reverse the array and insert based on the tile data given to us as an argument.
  # This also makes it so we can set the strings for 'empty' spaces as nil values if we want to without it causing side-effects.
  # 
  # This circumvents having to check each element in the nested array when all we want to do is insert something. The size,
  # layout, and ordering of the board stays consistent, which also allows us to do this without having to worry about edge-cases. 
  # 
  # Due to how we expect it to be displayed (in browser and console) as: 
  #   x (letters) on bottom, y (numbers) on left  
  #   _
  #   
  #    |
  #    |
  #    |
  #   y|_______
  #     x (letters)
  # 
  # as opposed to like this in a code representation
  #   x (letters) on top, y on left
  #   _
  #   
  #   x (letters)
  #    ________
  #  y|
  #   |
  #   |
  #   |

  # We just have to pivot on the x axis, essentially. 
  # 
  # It is easier to treat the array as if it has a 'pivot point' at
  # the top of it that allows us to translate our visual representation into a 'code' representation.
  # We 'pivot' the @data array by calling #reverse on it. (@data.reverse)
  # 
  # The method #place! automatically does this flip-flop for us using reversed_data and calling reversed_data.reverse
  # after it is done appending the correct objects. 
  # 
  # In short........
  # 
  # IF YOU ARE TRYING TO PLACE A PIECE, REMEMBER TO EITHER USE #place! USING DATA FROM THE METHOD #indexes_at OR REVERSE THE 
  # @data ARRAY BEFORE SETTING VALUES TO IT!
  # 
  # ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## #


  def indexes_at(tile)
    tile = tile.downcase

    # Splitting into ["a", "1"] if tile is "a1"
    chunks = tile.split("")

    # The number given to us is always going to be 1 less than the index we need to target on the y axis.
    y = chunks[1].to_i - 1

    # Check out helpers.rb. All this method does is translate letters into the corresponding index value.
    x = BoardHelper.index_alias_for(chunks[0])   
    return [y, x]
  end

  def place!(piece, tile)
    # Find the index in @data where the piece needs to be places
    indexes = indexes_at(tile)

    # Remember the important comment above? Read it again if you don't understand why we are reversing here. :)
    reversed_data = @data.reverse

    # Assigning simple variables to y and x for clarity...
    y, x = indexes[0], indexes[1]

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
      # if 'parent_index' is 0, 'set' would be: ['a8', 'b8', 'c8', 'd8', 'e8', 'f8', 'h8']
      set.each_with_index do |tile, child_index|
        
        # Looks at the labels for the current parent index (0-7 -> a..h) and pulls the 
        # label corresponding to the index and adds 1 to the current child_index (0-7) to give a string
        # back with the correct tile label. i.e. 'a1', 'd4', 'h8'
        label = labels[parent_index]

        # Setting the element to contain the string created in label + the corresponding y value
        set[child_index] = "#{label}#{child_index+1}"
      end
    end
    # We did this in order alphabetically and numerically from top to bottom, so 
    # transposing and reversing puts it in the correct 'visual' format for us.
    @data = scaffold.transpose.reverse
  end

  def new_game!
    # Setting it up so you can see the other coordinate labels when this is printed to the console...
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