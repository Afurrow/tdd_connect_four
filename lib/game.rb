class Game
    attr_accessor :board, :length, :width

    def initialize(col_num=7, row_num=6)
        @board = Array.new(row_num) {Array.new(col_num, " ")}
        @length = @board.length
        @width = @board[0].length
    end 

    def generate_board
        board_str = "\n  1   2   3   4   5   6   7  "
        for row in @board
            row_str = row.join(" | ")
            board_str = board_str + "\n#{'=' * (row_str.length()+4)}"
            board_str = board_str + "\n| #{row_str} |"
        end 
        board_str = board_str + "\n#{"=" * (row_str.length()+4)}\n\n"
        return board_str
    end 

    def place_marker(mark)
        sel = _receive_input(gets())
        puts(sel)
        len = @length - 1
        (0..len).each do |n|
            idx = len - n        
            if @board[idx][sel] == " "
                @board[idx][sel] = mark
                puts(self.generate_board())
                _check_winner(mark, [idx, sel])
                break
            end 
        end         
    end

    def _replace_board(new_board)
        @board = new_board
    end 

    def _receive_input(col)
        if col.to_i.between?(1, @width)
            col_vals = @board.map { |x| x[col.to_i-1] == " " }
            len = col_vals.count(true)
            if len > 0
                return col.to_i - 1
            else 
                puts("Please select a column with available spaces") 
                _receive_input(gets())
            end
        else 
            puts("Invalid input.  Please enter a number 1-#{@width}.")
            _receive_input(gets())
        end  
    end 

    def _check_winner(mark, cord)
        x, y = cord 
        h = @length - x
        row_str = @board[x].join()
        col_str = @board.map {|row| row[y]}.join()
        diags = _get_diags(x, y, h)
        rdiag_str = diags[0] ? diags[0].join() : "Insufficient Width" 
        ldiag_str = diags[1] ? diags[1].join() : "Insufficient Width" 
        avail_spaces = @board.map { |row| row.count(" ") }.sum()

        if row_str.include? mark*4 or col_str.include? mark*4 or 
        rdiag_str.include? mark*4 or ldiag_str.include? mark*4
            puts(generate_board)
            puts("#{mark} Wins!")
            puts("If you would like to play again please enter ""Yes""")
            _new_game?(gets())
        elsif avail_spaces == 0 
            puts(generate_board)
            puts("Draw")
            puts("If you would like to play again please enter ""Yes""")
            _new_game?(gets())
        end                 
    end 

    def _get_diags(x, y, h)
        diags = []     
        if h > 3 
            sides = [@width - y, y + 1]
            sides.each_with_index do |side, s|
                if side >= 4 
                    temp = []
                    [h, side].min.times do |i|
                        if s == 0 
                            temp.append(@board[x+i][y+i])
                        else 
                            temp.append(@board[x+i][y-i])
                        end 
                    end
                    diags.append(temp)
                else 
                    diags.append(nil)
                end
            end         
        end     
        return diags
    end 

    def _new_game?(sel)
        if sel.chomp().downcase == "yes"
            puts("\n"*5)
            initialize()
        else 
            puts("Thank you for playing!")
            exit!
        end 
    end 
end 

# bd = Game.new()

# while true
#     markers = ["X", "O"]
#     for mark in markers do
#         puts(bd.generate_board)
#         puts("Please select a column")
#         bd.place_marker(mark)
#     end            
# end