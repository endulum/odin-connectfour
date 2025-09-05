require "colorize"
require_relative "../lib/game_loop"

describe GameLoop do
  subject(:game_loop) { described_class.new }

  # Welcome to Connect Four

  # What's your name? > bob
  # Hello, bob! You will be playing red.

  # Enter 1 to be in one-player mode. You will play against the computer.
  # Enter 2 to be in two-player mode. You will play against a second person.
  #
  # > 1
  # The computer will play yellow.
  # [begin game]
  #
  # > 2
  # Second person, what's your name? > alice
  # Hello, alice! You will be playing yellow.
  # [begin game]

  describe "#init_player_one" do
    let(:valid_input) { "bob" }

    context "when input is successful" do
      it "displays success and returns value" do
        allow(game_loop).to receive(:input).and_return(valid_input)

        success_message = "Hello, #{valid_input.red}! You will be playing #{'red'.red}.".bold
        expect(game_loop).to receive(:puts).with(success_message)

        player_one_name = game_loop.init_player_one
        expect(player_one_name).to be valid_input
      end
    end

    context "when input is unsuccessful" do
      it "loops with error three times, then displays success once" do
        invalid_input_empty = ""
        invalid_input_too_long = Array.new(100, "x").join
        invalid_input_non_alpha = "12345"
        allow(game_loop).to receive(:input).and_return(
          invalid_input_empty, invalid_input_too_long, invalid_input_non_alpha, valid_input
        )

        expect(game_loop).to receive(:puts).with(/\s*Input error:/).exactly(3).times
        expect(game_loop).to receive(:puts).with(/(?!\s*Input error:)/).once

        game_loop.init_player_one
      end
    end
  end

  describe "#single_player?" do
    context "when input is successful" do
      context "when single-player chosen" do
        before do
          allow(game_loop).to receive(:input).and_return("1")
        end

        it "displays message and returns true" do
          expect(game_loop).to receive(:puts).with("The computer will play #{'yellow'.yellow}.".bold)
          is_single_player = game_loop.single_player?
          expect(is_single_player).to be true
        end
      end

      context "when two-player chosen" do
        before do
          allow(game_loop).to receive(:input).and_return("2")
        end

        it "does not display message (#init_player_two takes care of this)" do
          expect(game_loop).not_to receive(:puts)
          is_single_player = game_loop.single_player?
          expect(is_single_player).to be false
        end
      end
    end

    context "when input is unsuccessful" do
      it "loops with error" do
        invalid_input = "3"
        valid_input = "2"
        allow(game_loop).to receive(:input).and_return(
          invalid_input, valid_input
        )
        expect(game_loop).to receive(:puts).with(/\s*Input error:/).once
        game_loop.single_player?
      end
    end
  end

  describe "#init_player_two" do
    let(:valid_input) { "alice" }

    context "when in single-player mode" do
      subject(:game_loop_single_player) do
        game = described_class.new
        game.instance_variable_set(:@is_single_player, true)
        return game
      end

      it "does nothing and automatically returns nil" do
        expect(game_loop_single_player).not_to receive(:puts)
        player_two_name = game_loop_single_player.init_player_two
        expect(player_two_name).to be nil
      end
    end

    context "when in two-player mode" do
      subject(:game_loop_two_player) do
        game = described_class.new
        game.instance_variable_set(:@is_single_player, false)
        return game
      end

      context "when input is successful" do
        it "displays success and returns value" do
          allow(game_loop_two_player).to receive(:input).and_return(valid_input)

          success_message = "Hello, #{valid_input.yellow}! You will be playing #{'yellow'.yellow}.".bold
          expect(game_loop_two_player).to receive(:puts).with(success_message)

          player_two_name = game_loop_two_player.init_player_two
          expect(player_two_name).to be valid_input
        end
      end

      context "when input is unsuccessful" do
        it "loops with error" do
          invalid_input_empty = ""
          invalid_input_too_long = Array.new(100, "x").join
          invalid_input_non_alpha = "12345"
          allow(game_loop_two_player).to receive(:input).and_return(
            invalid_input_empty, invalid_input_too_long, invalid_input_non_alpha, valid_input
          )

          expect(game_loop_two_player).to receive(:puts).with(/\s*Input error:/).exactly(3).times
          expect(game_loop_two_player).to receive(:puts).with(/(?!\s*Input error:)/).once

          game_loop_two_player.init_player_two
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
