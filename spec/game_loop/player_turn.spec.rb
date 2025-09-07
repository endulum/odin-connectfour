require_relative "../../lib/game/game_loop"
require_relative "../../lib/prompt"
require_relative "../../lib/connect_four_board"
require "colorize"

describe GameLoop do
  subject(:game) do
    game = described_class.new
    game.instance_variable_set(:@player_one, { name: "bob", color: :red })
    return game
  end

  describe "#take_turn" do
    context "when it is nil" do
      it "sets @whose_turn to @player_one" do
        game.take_turn
        player_one = game.instance_variable_get(:@player_one)
        whose_turn = game.whose_turn
        expect(whose_turn).to be player_one
      end
    end

    context "when it is @player_one" do
      before do
        game.instance_variable_set(:@player_two, { name: "alice", color: :yellow })
        player_one = game.instance_variable_get(:@player_one)
        game.instance_variable_set(:@whose_turn, player_one)
      end

      it "sets @whose_turn to @player_two" do
        game.take_turn
        player_two = game.instance_variable_get(:@player_two)
        whose_turn = game.whose_turn
        expect(whose_turn).to be player_two
      end
    end

    context "when it is @player_two" do
      before do
        player_two = { name: "alice", color: :yellow }
        game.instance_variable_set(:@player_two, player_two)
        game.instance_variable_set(:@whose_turn, player_two)
      end

      it "sets @whose_turn to @player_two" do
        game.take_turn
        player_one = game.instance_variable_get(:@player_one)
        whose_turn = game.whose_turn
        expect(whose_turn).to be player_one
      end
    end
  end

  describe "#call_move" do
    context "when it is player one's turn" do
      before do
        player_one = game.instance_variable_get(:@player_one)
        game.instance_variable_set(:@whose_turn, player_one)
      end

      it "calls #prompt_player_move" do
        expect(game).to receive(:prompt_player_move)
        game.call_move
      end
    end

    context "when it is player two's turn, and mode is 1p" do
      before do
        player_two = { name: "The Computer", color: :yellow }
        game.instance_variable_set(:@player_two, player_two)
        game.instance_variable_set(:@play_mode, "1p")
        game.instance_variable_set(:@whose_turn, player_two)
      end

      it "calls #play_computer_move" do
        expect(game).to receive(:play_computer_move)
        game.call_move
      end
    end

    context "when it is player two's turn, and mode is 2p" do
      before do
        player_two = { name: "alice", color: :yellow }
        game.instance_variable_set(:@player_two, player_two)
        game.instance_variable_set(:@play_mode, "2p")
        game.instance_variable_set(:@whose_turn, player_two)
      end

      it "calls #prompt_player_move" do
        expect(game).to receive(:prompt_player_move)
        game.call_move
      end
    end
  end

  describe "#prompt_player_move" do
    describe "printing the prompt" do
      context "when 'bob' with a :red token" do
        before do
          allow(game).to receive(:valid_column?).and_return true
          player_one = game.instance_variable_get(:@player_one)
          game.instance_variable_set(:@whose_turn, player_one)
        end

        it "prints properly" do
          text = "It's your turn, #{'bob'.red}. Place a #{'red'.red} token in which column?\n> ".bold
          expect(Prompt).to receive(:print).with text
          game.prompt_player_move
        end
      end

      context "when 'alice' with a :yellow token" do
        before do
          allow(game).to receive(:valid_column?).and_return true
          player_two = { name: "alice", color: :yellow }
          game.instance_variable_set(:@player_two, player_two)
          game.instance_variable_set(:@play_mode, "2p")
          game.instance_variable_set(:@whose_turn, player_two)
        end

        it "prints properly" do
          text = "It's your turn, #{'alice'.yellow}. Place a #{'yellow'.yellow} token in which column?\n> ".bold
          expect(Prompt).to receive(:print).with text
          game.prompt_player_move
        end
      end
    end

    describe "getting the input" do
      subject(:game) do
        game = described_class.new
        player_one = { name: "bob", color: :red }
        game.instance_variable_set(:@player_one, player_one)
        game.instance_variable_set(:@whose_turn, player_one)
        game.instance_variable_set(:@board, board)
        return game
      end

      let(:board) { instance_double(ConnectFourBoard) }

      context "when valid input" do
        before do
          valid_input = "0"
          allow(Prompt).to receive(:get_input).and_return(valid_input)
          allow(board).to receive(:column_full?).and_return false
        end

        it "stops loop" do
          expect(game).not_to receive(:puts)
          game.prompt_player_move
        end
      end

      context "when invalid input" do
        before do
          invalid_input = "b"
          valid_input = "0"
          allow(Prompt).to receive(:get_input).and_return(invalid_input, valid_input)
          allow(board).to receive(:column_full?).and_return false
        end

        it "loops once and displays proper message" do
          text = "Input error: please enter a column number 0 through 6!".bold
          expect(game).to receive(:puts).with(text).once
          game.prompt_player_move
        end
      end

      context "when column is full" do
        before do
          invalid_input = "1"
          valid_input = "0"
          allow(board).to receive(:column_full?).with(invalid_input.to_i).and_return true
          allow(board).to receive(:column_full?).with(valid_input.to_i).and_return false
          allow(Prompt).to receive(:get_input).and_return(invalid_input, valid_input)
        end

        it "loops once and displays proper message" do
          text = "Input error: that column is full, choose another!".bold
          expect(game).to receive(:puts).with(text).once
          game.prompt_player_move
        end
      end
    end
  end
end
