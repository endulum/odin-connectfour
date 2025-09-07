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
end
