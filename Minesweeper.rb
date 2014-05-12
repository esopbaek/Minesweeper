class Tile
  
  DELTAS = [[0,1], [0,-1], [1,0], [-1,0], [1,1], [-1,1], [-1,-1], [1,-1]]
  
  # attr_reader :bombed
  attr_accessor :flagged :revealed
  
  def initialize(pos)
    @bombed = false
    @flagged = false
    @revealed = false
  end
  
  def bombed?
    @bombed
  end
  
  def neighbors(pos)
    DELTAS.map {|x,y| [x+pos[0],y+pos[1]]}
  end
  
  def neighbor_bomb_count
    count = 0
    neighbors.each {|neighbor| count += 1 if neighbor.bombed? }
    count
  end
  
  
  

  
end