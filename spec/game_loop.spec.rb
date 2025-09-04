require_relative "../lib/game_loop"
require_relative "../lib/prompt"
require "colorize"

describe GameLoop do
  subject(:game) { described_class.new }

  describe "initialization driver" do
    describe "#init_player_one" do
      context "when name is valid" do
        before do
          valid_input = "bob"
          allow(Prompt).to receive(:get_input).and_return(valid_input)
        end

        it "stops loop and displays confirmation message" do
          expect(game).to receive(:puts).with(
            "Hello, #{'bob'.red}. You will be playing #{'red'.red}.".bold
          )
          game.init_player_one
        end
      end

      context "when name is invalid" do
        before do
          invalid_empty = ""
          invalid_too_long = Array.new(100, "x").join
          invalid_non_alpha = "12345"
          valid_input = "bob"
          allow(Prompt).to receive(:get_input).and_return(
            invalid_empty, invalid_too_long, invalid_non_alpha, valid_input
          )
        end

        it "loops with error message three times, then displays confirmation message once" do
          expect(game).to receive(:puts).with(/\s*Input error:/).exactly(3).times
          expect(game).to receive(:puts).with(
            "Hello, #{'bob'.red}. You will be playing #{'red'.red}.".bold
          ).once
          game.init_player_one
        end
      end
    end

    describe "#init_play_mode" do
      context "when play mode is valid" do
        before do
          valid_input = "1p"
          allow(Prompt).to receive(:get_input).and_return(valid_input)
        end

        it "stops loop and does not display a message" do
          expect(game).not_to receive(:puts).with(/\s*Input error:/)
          game.init_play_mode
        end
      end

      context "when play mode is invalid" do
        before do
          valid_input = "2p"
          invalid_input = "3p"
          allow(Prompt).to receive(:get_input).and_return(invalid_input, valid_input)
        end

        it "loops with error message once" do
          expect(game).to receive(:puts).with(/\s*Input error:/).once
          game.init_play_mode
        end
      end
    end

    describe "#init_cpu_player" do
      it "displays a message" do
        expect(game).to receive(:puts).with(
          "The computer will play #{'yellow'.yellow}.".bold
        )
        game.init_cpu_player
      end
    end

    describe "#init_player_two" do
      context "when name is valid" do
        before do
          valid_input = "alice"
          allow(Prompt).to receive(:get_input).and_return(valid_input)
        end

        it "stops loop and displays confirmation message" do
          expect(game).to receive(:puts).with(
            "Hello, #{'alice'.yellow}. You will be playing #{'yellow'.yellow}.".bold
          )
          game.init_player_two
        end
      end

      context "when name is invalid" do
        before do
          invalid_empty = ""
          invalid_too_long = Array.new(100, "x").join
          invalid_non_alpha = "12345"
          valid_input = "alice"
          allow(Prompt).to receive(:get_input).and_return(
            invalid_empty, invalid_too_long, invalid_non_alpha, valid_input
          )
        end

        it "loops with error message three times, then displays confirmation message once" do
          expect(game).to receive(:puts).with(/\s*Input error:/).exactly(3).times
          expect(game).to receive(:puts).with(
            "Hello, #{'alice'.yellow}. You will be playing #{'yellow'.yellow}.".bold
          ).once
          game.init_player_two
        end
      end

      describe "#driver_init" do
        context "when 1p mode selected" do
          player_one_name = "bob"
          play_mode = "1p"

          before do
            allow(Prompt).to receive(:get_input).and_return(
              player_one_name, play_mode
            )
          end

          it "works" do
            expect(game).to receive(:puts).at_least(:once)
            game.driver_init
            expect(game.player_one).to eq({ name: player_one_name, color: :red })
            expect(game.play_mode).to eq "1p"
            expect(game.player_two).to eq({ name: "The Computer", color: :yellow })
          end
        end

        context "when 2p mode selected" do
          player_one_name = "bob"
          play_mode = "2p"
          player_two_name = "alice"

          before do
            allow(Prompt).to receive(:get_input).and_return(
              player_one_name, play_mode, player_two_name
            )
          end

          it "works" do
            expect(game).to receive(:puts).at_least(:once)
            game.driver_init
            expect(game.player_one).to eq({ name: player_one_name, color: :red })
            expect(game.play_mode).to eq "2p"
            expect(game.player_two).to eq({ name: player_two_name, color: :yellow })
          end
        end
      end
    end

    # the init driver script:
    # invoke init_player_one
    # invoke init_play_mode
    # based on play_mode, either invoke init_cpu_player or init_player_two
    # ensure that GameLoop@player_one, @player_two, @play_mode are correctly defined
  end
end
