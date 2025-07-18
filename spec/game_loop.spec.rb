require_relative "../lib/game_loop"

describe GameLoop do
  describe "initializing the game" do
    describe "inputting a name" do
      context "when no name is given" do
        it "loops once with error" do
          #
        end
      end

      context "when valid name is given" do
        it "stops loop and does not error" do
          #
        end
      end
    end

    describe "inputting a color" do
      context "when no color is given" do
        it "loops once with error" do
          #
        end
      end

      context "when input does not match a valid Colorize token" do
        it "loops once with error" do
          #
        end
      end

      context "when input matches a valid Colorize token" do
        it "stops loop and does not error" do
          #
        end
      end
    end

    describe "selecting 1-player or 2-player mode" do
      context "when invalid input" do
        it "loops once with error" do
          #
        end
      end

      context "when valid input, 1-player mode" do
        it "stops loop, does not error, and calls for 1p mode" do
          #
        end
      end

      context "when valid input, 2-player mode" do
        it "stops loop, does not error, and calls for 2p mode" do
          #
        end
      end
    end
  end

  describe "playing the game" do
    describe "playing turns" do
      context "when input is given by player" do
        it "uses input to affect the grid" do
          #
        end
      end
    end

    describe "switching turns" do
      context "when game starts" do
        it "asks for input from player 1" do
          #
        end
      end

      context "when player 1 provides input" do
        it "asks for input from player 2" do
          #
        end
      end

      context "when player 2 provides input" do
        it "asks for input from player 1" do
          #
        end
      end
    end

    describe "performing a winning turn" do
      context "when turn is not a winning turn" do
        it "does not end the game" do
          #
        end
      end

      context "when turn is a winning turn" do
        it "ends the game" do
          #
        end
      end
    end
  end
end
