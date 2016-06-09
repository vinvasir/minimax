class TicTacToe
  attr_accessor :computer_symbol, :computer_choice, :board
  
  def initialize(computer_symbol, board=Array.new(9, " "))
    @board = board
    @computer_symbol = computer_symbol
  end
  
  def score
    if winner == @computer_symbol
        return 10
    elsif draw?
        return 0
    else
        return -10
    end
  end
  
  def minimax(game=self)
    return score if game.over?
    scores = [] # an array of scores
    moves = []  # an array of move indeces on the board

    # Populate the scores array, recursing as needed
    game.available_moves.each do |move_index|  #this forced me to change the TicTacToe class. remember to double-check it
        possible_board = game.board.dup
        possible_board[move_index] = @computer_symbol
        possible_game = TicTacToe.new(@computer_symbol, possible_board)
        scores.push minimax(possible_game) #need some way of passing the possible_game into minimax. Does this work?
        moves.push move_index
    end

    # Do the min or the max calculation
    if game.current_player == @computer_symbol
        # This is the max calculation
        max_score_index = scores.each_with_index.max[1]
        @choice = moves[max_score_index]
        return scores[max_score_index]
    else
        # This is the min calculation
        min_score_index = scores.each_with_index.min[1]
        @computer_choice = moves[min_score_index]
        return scores[min_score_index]
    end
  end
  
  def computer_move
    minimax
    @board[@computer_choice] = @computer_symbol
    display_board
  end

  WIN_COMBINATIONS = [
  [0, 1, 2], #top row, remember commas after each sub-array
  [3, 4, 5], #middle row
  [6, 7, 8], #bottom row
  [0, 4, 8], #diagonal left
  [6, 4, 2], #diagonal right
  [0, 3, 6], #left column
  [1, 4, 7], #middle column
  [2, 5, 8] #right column
  ]



  def display_board
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} "
    puts "-----------"
    puts " #{@board[3]} | #{@board[4]} | #{@board[5]} "
    puts "-----------"
    puts " #{@board[6]} | #{@board[7]} | #{@board[8]} "
  end

  def move(location, marker = "X")
    @board[location.to_i-1] = marker
  end

  def position_taken?(location)
    @board[location] != " " && @board[location] != ""
  end

  def valid_move?(position)
    position.to_i.between?(1,9) && !position_taken?(position.to_i-1)
  end

  def available_moves #this should return an array of index positions that are empty
    @avail = []
    @board.each_with_index do |position, index|
      @avail.push(index) if position == " "
    end
    return @avail
  end

  def turn
    if current_player == @computer_symbol
      computer_move
    else
      puts "Please enter 1-9:"
      input = gets.strip
      if valid_move?(input)
        move(input, current_player) #this should use the current_player method as an argument
      else
        turn
      end
      display_board
    end  
  end

  def won?

    matches = WIN_COMBINATIONS.select do |combo|

      o_wins = combo.all? do |space|
        @board[space]=="O"  #needed to change it to just board[space]. Also needed to remove the "if" I had here, because "all?" already checks for truth
      end #end of combo.all? and the "winning" declaration
        
      x_wins = combo.all? do |space|
        @board[space]=="X"  #needed to change it to just board[space]. Also needed to remove the "if" I had here, because "all?" already checks for truth
      end #end of combo.all? and the "winning" declaration

      o_wins || x_wins # this was the key that allowed me to win. could also condense the combo.all? methods' code blocks into curlicue brackets
    end #end of WIN_COMBINATONS.each
    
    final_check = matches.any? do |i|
      i.length>1
    end
    
    if final_check
      return matches[0]
    else
      return false
    end #end of the return conditional
  end # end of the won? method

  def full?
    @board.all? do |space|
      space=="X" || space=="O"
    end
  end

  def draw?
    if !won? && full?
        return true   #if this is returning true for a won game, that means some types of won games are returning false in my #won? method. Which ones and why?
      else
        return false
      end
  end

  def over?
    if won? || draw?
      return true
    else
      return false
    end
  end

  def winner
    win_index=won? #needed to get an index for pulling out X or O itself, not just the index number. I did that based on the won? method's return value
    if won?
      return @board[win_index[0]]
    end
  end

  def turn_count
    turn_array = @board.select do |occupied|
      occupied != " " && occupied != ""
    end
    return turn_array.length  #can simplify this as seen in the penultimate readme lesson
  end

  def current_player
    if turn_count % 2 == 1
      return "O"
    else
      return "X"
    end
  end

# Define your play method below
  def play
    i=0
    while i<9 && !over?
      turn
      i+=1
    end
    if draw?
      puts "Cats Game!"
    end
    if won?
      puts "Congratulations #{winner}!"
    end
  end
end #end of the TicTacToe class