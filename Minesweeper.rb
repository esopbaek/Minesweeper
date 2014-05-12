class Board
  def initialize(width,height,mines)
    @width = width
    @height = height
    @board = Array.new(height) { Array.new(width)}
    @mines = mines
    setup
  end
  
  def setup
    @board.height.times do |x|
      @board.width.times do |y|
      end
    end
  end
  
  
  
  
end





class Tile
  
  DELTAS = [[0,1], [0,-1], [1,0], [-1,0], [1,1], [-1,1], [-1,-1], [1,-1]]
  
  attr_reader :pos
  attr_accessor :flagged :revealed
  
  def initialize(pos, board)
    @pos = pos
    @bombed = false
    @flagged = false
    @revealed = false
    @ignited = false
    @board = board
  end
  
  def bombed?
    @bombed
  end
  
  def flagged?
    @flagged
  end
  
  def neighbors
    DELTAS.map {|x,y| [x + @pos[0],y + @pos[1]]}
  end
  
  def neighbor_bomb_count
    count = 0
    neighbors.each {|neighbor| count += 1 if neighbor.bombed? }
    count
  end
  
  def display
    if flagged?
      "F"
    elsif !revealed
      "*"
    elsif ignited
      "X"
    else
      if neighbor_bomb_count > 0
        neighbor_bomb_count
      else
        "_"
      end
    end
  end
  
  def explore(tile)
    if tile.neighbor_bomb_count > 0
      tile.reveal
    else
      tile.neighbors.each do |neighbor|
        explore(@board(neighbor))
      end
    end
  end
  
  def flag
    @flagged = true
    reveal(self.pos)
  end
  
  def reveal(pos)
    if flagged?
      display
    elsif bombed?
      @ignited = true
      display
    elsif neighbor_bomb_count.count > 0
      display
    else
      explore(self)
    end
  end
   
end