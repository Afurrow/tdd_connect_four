require './lib/game'

describe '#Connect Four Game' do
    subject(:game) { Game.new }

    context "initialize" do 
        it "generates board" do         
            new_board = [[" ", " ", " ", " ", " ", " ", " "],
                         [" ", " ", " ", " ", " ", " ", " "],
                         [" ", " ", " ", " ", " ", " ", " "],
                         [" ", " ", " ", " ", " ", " ", " "],
                         [" ", " ", " ", " ", " ", " ", " "],
                         [" ", " ", " ", " ", " ", " ", " "]]
            expect(game.board).to eq(new_board)
        end 
    end 
    
    context "generate_board" do 
        it "generates string version of board" do
            board_str = """
  1   2   3   4   5   6   7  
=============================
|   |   |   |   |   |   |   |
=============================
|   |   |   |   |   |   |   |
=============================
|   |   |   |   |   |   |   |
=============================
|   |   |   |   |   |   |   |
=============================
|   |   |   |   |   |   |   |
=============================
|   |   |   |   |   |   |   |
=============================

"""
            expect(board_str).to eq(game.generate_board())  
        end 
    end 

    context "place_marker" do
        before do
            allow_any_instance_of(Game).to receive(:puts).and_return(double().as_null_object)
            allow(game).to receive(:gets).and_return("5")
            allow(game).to receive(:_receive_input).with("5").and_return(4)
        end 

        it "changes board" do
            expect { game.place_marker("X") }.to change { game.board }
        end


    end 

    context "_replace_board" do 
        it "replaces board with input" do
            new_board = [[" "," "," "," "," "," "," "],
                        [" "," "," "," "," "," "," "],
                        [" "," "," "," "," "," "," "],
                        [" "," "," "," "," "," "," "],
                        [" "," "," "," "," "," "," "],
                        [" ","X","X","X","X"," "," "]] 

            game._replace_board(new_board)
            expect(game.board).to eq(new_board)
        end
    end  
    


    context '_receive_input' do
        it "receives valid input"  do
            expect(game._receive_input(5)).to eq(4)        
        end 

        before do 
            allow_any_instance_of(Game).to receive(:puts).and_return(double().as_null_object)
            allow(game).to receive(:gets).and_return("T", "5", "1")
        end 

        it "fails twice then returns" do        
            expect(game._receive_input("T")).to eq(4)
        end 

        it "receives input for column with no available spaces" do 
            new_board = [[" "," ","X"," "," "," "," "],
                         [" "," ","X"," "," "," "," "],
                         [" "," ","X"," "," "," "," "],
                         [" "," ","X"," "," "," "," "],
                         [" "," ","X"," "," "," "," "],
                         [" "," ","X"," "," "," "," "]] 
    
            game._replace_board(new_board)
            allow(game).to receive(:gets).and_return("1")
            expect(game).to receive(:puts).with("Please select a column with available spaces")
            game._receive_input("3") 
        end 
    end 

    context "_check_winner" do         
        before do   
            allow_any_instance_of(Game).to receive(:puts).and_return(double().as_null_object)          
            allow(game).to receive(:gets).and_return("No")
        end 

        it "finds one" do
            new_board = [[" "," "," "," "," "," "," "],
                         [" "," "," "," "," "," "," "],
                         [" "," "," "," "," "," "," "],
                         [" "," "," "," "," "," "," "],
                         [" "," "," "," "," "," "," "],
                         [" ","X","X","X","X"," "," "]] 

            game._replace_board(new_board)
            expect(game).to receive(:_new_game?)
            game._check_winner("X", [5, 1])
        end 

        it "fails to find one" do
            expect(game).to_not receive(:_new_game?)
        end 

        it "discovers a tie" do 
            new_board = [["X","X","X","O","X","X","X"],
                         ["O","O","O","X","O","O","O"],
                         ["X","X","X","O","X","X","X"],
                         ["O","O","O","X","O","O","O"],
                         ["X","X","X","O","X","X","X"],
                         ["O","O","O","X","O","O","O"]] 
            game._replace_board(new_board)
            expect(game).to receive(:_new_game?)
            game._check_winner("X", [0,1])
        end 
    end 

   context "_get_diags" do
        it "returns blank array when height is insufficient" do
            expect(game._get_diags(4, 3, 2)).to eq([]) 
        end 

        it "returns diagonal options when height is sufficient" do 
            expect(game._get_diags(2, 3, 4)).to eq([[" ", " ", " ", " "], [" ", " ", " ", " "]])
        end 
   end 

    context "_new_game?" do 
        before do 
            allow_any_instance_of(Game).to receive(:puts).and_return(double().as_null_object) 
        end 

        it "re-initializes" do 
            expect(game).to receive(:initialize)
            game._new_game?("yes")
        end 

        it "exits program" do 
            expect(game).to receive(:exit!)
            game._new_game?("no")
        end 
    end     
end