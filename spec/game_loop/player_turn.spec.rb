require_relative "../../lib/game/game_loop"
require_relative "../../lib/prompt"
require_relative "../../lib/connect_four_board"
require "colorize"

describe GameLoop do
  subject(:game_1p) do
    game = described_class.new
    allow(game).to receive(:player_one).and_return(
      { name: "bob", color: :red }
    )
    allow(game).to receive(:play_mode).and_return("1p")
    allow(game).to receive(:player_two).and_return(
      { name: "The Computer", color: :yellow }
    )
    return game
  end

  subject(:game_2p) do
    game = described_class.new
    allow(game).to receive(:player_one).and_return(
      { name: "bob", color: :red }
    )
    allow(game).to receive(:play_mode).and_return("2p")
    allow(game).to receive(:player_two).and_return(
      { name: "alice", color: :yellow }
    )
    return game
  end

  describe "#begin_game" do
    before do
      game_1p.begin_game
    end

    it "sets up the board" do
      expect(game_1p.board).to be_instance_of ConnectFourBoard
    end

    it "ensures player 1 goes first" do
      expect(game_1p.whose_turn).to eq game_1p.player_one
    end
  end
end
