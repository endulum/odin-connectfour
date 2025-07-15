require_relative "../lib/player-loop"
require_relative "../lib/grid"

describe PlayerLoop do
  subject(:player_loop) { described_class.new("bob", :red) }
  subject(:grid) { Grid.new }

  describe "making a move" do
    context "when valid move input" do
      it "stops loop and does not error" do
        valid_input = "0"
        allow(player_loop).to receive(:input).and_return(valid_input)
        expect(player_loop).not_to receive(:puts).with(/^\s*Input error!/)
        player_loop.play_turn
      end
    end

    context "when invalid move input, then valid input" do
      before do
        valid_input = "0"
        invalid_input = "wow"
        allow(player_loop).to receive(:input).and_return(
          invalid_input, valid_input
        )
      end

      it "continues loop and errors once" do
        expect(player_loop).to receive(:puts).with(/^\s*Input error!/).once
        player_loop.play_turn
      end
    end
  end
end
