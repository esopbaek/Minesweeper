class Minesweeper
  
  def initialize
    @board = Board.new(20,20,70)
  end
  
  def play
    until @board.over
      coordinates = get_user_coordinates
      action = get_user_action
      @board[coordinates].flag if action == 'f'
      @board[coordinates].reveal if action == 'r'
      @board.display
    end
    @board.display
    puts "You lose"
  end
  
  def get_user_coordinates
    puts "Please enter coordinates (x,y)"
    gets.chomp.split(",").map(&:to_i)
  end
  
  def get_user_action
    puts "Enter f to flag, r to reveal"
    action = gets.chomp
  end

end




class Board
  
  attr_accessor :board, :over
  attr_reader :height, :width
  
  def initialize(width,height,mines)
    @width = width
    @height = height
    @board = Array.new(height) { Array.new(width) }
    @mines = mines
    @over = false
    setup
    display

  end
  
  def [](pos)
    x, y = pos[0], pos[1]
    @board[x][y]
  end
  
  
  
  def []=(pos, tile)
    x, y = pos[0], pos[1]
    @board[x][y] = tile
  end
    
  def setup
    @height.times do |x|
      @width.times do |y|
        self[[x, y]] = Tile.new([x,y], self)
      end
    end 

    self.fill_with_mines
  end
  
  def display
    @height.times do |x|
      @width.times do |y|
        print self[[x,y]].display + "  "
      end
      puts
    end
    puts
  end
  
  def fill_with_mines
    get_mine_positions.each do |mine_pos|
      x,y = mine_pos[0], mine_pos[1]
      self[[x,y]].bombed = true
    end
  end
  
  def get_mine_positions
    mine_positions = []
    until mine_positions.count == @mines
      mine = [rand(@height), rand(@width)]
      mine_positions << mine unless mine_positions.include?(mine)
    end
    mine_positions
  end
  
  def reveal_bombs
    @board.each do |rows|
      rows.each do |tile|
        tile.reveal if tile.bombed
      end
    end
  end
  
  def over?
    @over
  end
  
end





class Tile
  
  DELTAS = [[0,1], [0,-1], [1,0], [-1,0], [1,1], [-1,1], [-1,-1], [1,-1]]
  
  attr_reader :pos
  attr_accessor :flagged, :revealed, :bombed, :ignited
  
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
    neighbors = DELTAS.map {|x,y| [x + @pos[0],y + @pos[1]]}
    neighbors = neighbors.select { |x, y| x.between?(0,@board.height-1) && y.between?(0, @board.width-1)}
    neighbors = neighbors.reject { |x,y| @board[[x,y]].revealed}
  end
  
  def neighbor_bomb_count
    count = 0
    self.neighbors.each {|neighbor| count += 1 if @board[neighbor].bombed? }
    count
  end
  
  def display
    if @board.over
      if self.flagged?
        "\u2691".encode('utf-8')
      elsif self.revealed
        if neighbor_bomb_count > 0
          neighbor_bomb_count.to_s
        else
          "\u00A0".encode('utf-8') # blank
        end
      else
        if self.bombed
          "X" # bomb
        else
          "\u204E".encode('utf-8') # asterisk
        end
      end
      
    else # game not over
      if self.flagged?
        "\u2691".encode('utf-8') # flag
      elsif !revealed
        "\u204E".encode('utf-8') # asterisk
      else
        if neighbor_bomb_count > 0
          neighbor_bomb_count.to_s
        else
          "\u00A0".encode('utf-8') # blank
        end
      end
    end 
  end
  
  def explore(tile)
    stack = [tile]
    until stack.empty?
      current = stack.shift
      current.neighbors.each do |pos|
        if @board[pos].neighbor_bomb_count == 0 && !stack.include?(@board[pos])
          @board[pos].reveal
          stack.push @board[pos]
        elsif @board[pos].neighbor_bomb_count > 0
          @board[pos].reveal
        end
      end
    end
  end
  
  def flag
    @flagged = true
    reveal
  end
  
  def reveal
    @revealed = true
    if self.flagged?
      display
    elsif self.bombed?
      @board.over = true
      display
    elsif self.neighbor_bomb_count > 0
      display
    else
      explore(self)
    end
  end
   
end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new
  game.play
end