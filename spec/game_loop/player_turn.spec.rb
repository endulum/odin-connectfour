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

  define "#take_turn" do
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
        game.instance_variable_set(
          :@player_two, { name: "alice", color: :yellow }
        )
      end

      it "sets @whose_turn to @player_two" do
        game.take_turn
        player_two = game.instance_variable_get(:@player_two)
        whose_turn = game.whose_turn
        expect(whose_turn).to be player_two
      end
    end
  end
end
