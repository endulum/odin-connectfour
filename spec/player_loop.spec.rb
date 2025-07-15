require_relative "../lib/player_loop"
require_relative "../lib/grid"

describe PlayerLoop do
  describe "prompting input" do
    context "when input is valid, and column is not full" do
      subject(:player_loop) { described_class.new(:red, bob, Grid.new) }

      before do
        valid_input = "0"
        allow(player_loop).to receive(:input).and_return(valid_input)
      end

      it "stops loop and does not error" do
        expect(player_loop).not_to receive(:puts).with(/^\s*Input error:/)
        player_loop.play_turn
      end
    end

    context "when input is valid, and column is full" do
      let!(grid) { Grid.new }
      subject(:player_loop) { described_class.new(:red, bob, grid) }

      before do
        6.times { grid.drop_token(player_loop.color, 0) }
        invalid_input = "0"
        valid_input = "2"
        allow(player_loop).to receive(:input).and_return(
          invalid_input, valid_input
        )
      end

      it "loops once with error" do
        expect(player_loop).to receive(:puts).with("Input error: This column is full. Please select another column.")
        player_loop.play_turn
      end
    end

    context "when input is invalid" do
      subject(:player_loop) { described_class.new(:red, bob, Grid.new) }

      before do
        invalid_input = "owo"
        valid_input = "0"
        allow(player_loop).to receive(:input).and_return(
          invalid_input, valid_input
        )
      end

      it "loops once with error" do
        expect(player_loop).to receive(:puts).with("Input error: Not a valid column. Please input an integer 0 to 6.")
        player_loop.play_turn
      end
    end
  end
end
