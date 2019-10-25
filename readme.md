## Chess Example

Be sure to read it over and discuss what's going on and how you might be able to use some of these ideas to approach your own code.

The main entry point for the code is 'game.rb'. 

##### This code will not run in rails as-is. It's supposed to look spooky, so don't feel intimidated by it. Google around and try things out - you can always pull a new coy down if you really mess it up while tinkering. Log things out - translate ideas into your own app. 

A lot of this code is based on the Hash data structure. I would recommend doing some reading on them if you aren't familiar with how they work: https://ruby-doc.org/core-2.5.1/Hash.html

TL;DR, they are ways you can name data and assign other data to those names. The chain of naming can go on forever, but you have to be aware of complexity.

#### helper.rb
The BoardHelper class provides us with a bunch of cool reference data. This isn't normally the case, but since we are just referencing static data it's ok to put it here for now. It defines how you expect the data to be structured, and represents part of your app's data schema as you take a closer look at how the 'nouns' are laid out. Think database columns...

#### board.rb
As for 'verbs', the Board class in board.rb does all of the heavy lifting. We use a lot of iteration, primarily because we need to be able to see what's going on in our data and change it as we see fit. We also have some save and transformation logic happening to the board based on the pieces given to it. Models sound familiar...

#### piece.rb
This is a parent class for the other pieces (King, Queen, Knight, Rook, Bishop and Pawn) that allows the child classes to attain the #location and #color attributes. The child classes pass their arguments to 'super' (which is referring to the Piece class it inherits from), allowing us to initialize the individual piece (King.new(color, tiile) for example) with the argments passed to the child object.

