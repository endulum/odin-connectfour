require_relative "../lib/connect_four_board"

describe ConnectFourBoard do
  subject(:board) { described_class.new }

  describe "#valid_token?" do
    context "when not a symbol" do
      not_a_symbol = "red"

      it "returns false" do
        valid = described_class.valid_token? not_a_symbol
        expect(valid).to be false
      end
    end

    context "when not a Colorize symbol" do
      not_a_colorize_symbol = :pink

      it "returns false" do
        valid = described_class.valid_token? not_a_colorize_symbol
        expect(valid).to be false
      end
    end

    context "when a Colorize symbol" do
      colorize_symbol = :red

      it "returns true" do
        valid = described_class.valid_token? colorize_symbol
        expect(valid).to be true
      end
    end
  end

  describe "#column_full?" do
    column = 0
    color = :red

    context "when column is empty" do
      it "returns false" do
        column_full = board.column_full?(column)
        expect(column_full).to be false
      end
    end

    context "when column is nearly full" do
      before { 5.times { board.drop_token(color, column) } }

      it "returns false" do
        column_full = board.column_full?(column)
        expect(column_full).to be false
      end
    end

    context "when column is full" do
      before { 6.times { board.drop_token(color, column) } }

      it "returns true" do
        column_full = board.column_full?(column)
        expect(column_full).to be true
      end
    end
  end

  describe "#drop_token" do
    color = :red
    column = 0

    context "when a column is empty" do
      it "occupies first space in column" do
        expect { board.drop_token(color, column) }
          .to change { board.grid.at_column(column) }
          .from([nil, nil, nil, nil, nil, nil])
          .to([color, nil, nil, nil, nil, nil])
      end
    end

    context "when a column has a token" do
      before { board.drop_token(color, column) }

      it "occupies second space in column" do
        expect { board.drop_token(color, column) }
          .to change { board.grid.at_column(column) }
          .from([color, nil, nil, nil, nil, nil])
          .to([color, color, nil, nil, nil, nil])
      end
    end

    context "when a column is nearly full" do
      before { 5.times { board.drop_token(color, column) } }

      it "occupies last space in column" do
        expect { board.drop_token(color, column) }
          .to change { board.grid.at_column(column) }
          .from([color, color, color, color, color, nil])
          .to([color, color, color, color, color, color])
      end
    end

    context "invalid arguments" do
      context "when a token is not valid" do
        it "does nothing" do
          expect { board.drop_token("red", column) }
            .not_to(change { board.grid.at_column(column) })
        end
      end

      context "when a column is full" do
        before { 6.times { board.drop_token(color, column) } }

        it "does nothing" do
          expect { board.drop_token(color, column) }
            .not_to(change { board.grid.at_column(column) })
        end
      end
    end
  end

  describe "winning_move?" do
    context "when not a winning move" do
      before do
        3.times { board.drop_token(:yellow, 0) }
      end

      it "returns false" do
        dropped_token_coords = board.drop_token(:red, 0)
        winning_move = board.winning_move?(dropped_token_coords, :red)
        expect(winning_move).to be false
      end
    end

    context "when a winning move" do
      before do
        3.times { board.drop_token(:red, 0) }
      end

      it "returns false" do
        dropped_token_coords = board.drop_token(:red, 0)
        winning_move = board.winning_move?(dropped_token_coords, :red)
        expect(winning_move).to be true
      end
    end
  end

  describe "#print" do
    def get_text(filename)
      text = File
             .read(filename)
             .strip
             .gsub("\\e", "\e")
             .gsub("\\n", "\n")
      text << "\n"
      text
    end

    context "when board is empty" do
      it "prints an empty grid" do
        text = get_text("spec/sample_grids/empty.txt")
        expect { puts board.print }.to output(text).to_stdout
        # puts text
      end
    end

    context "when board has one red token and one yellow token" do
      before do
        board.drop_token(:red, 0)
        board.drop_token(:yellow, board.grid.column_count - 1)
      end

      it "prints a grid with one red token and one yellow token" do
        text = get_text("spec/sample_grids/one-red-one-yellow.txt")
        expect { puts board.print }.to output(text).to_stdout
        # puts text
      end
    end

    context "when board has full red column and full yellow column" do
      before do
        6.times { board.drop_token(:red, 0) }
        6.times { board.drop_token(:yellow, 6) }
      end

      it "prints a grid with full red column and full yellow column" do
        text = get_text("spec/sample_grids/col-red-col-yellow.txt")
        expect { puts board.print }.to output(text).to_stdout
        # puts text
      end
    end

    context "when board has full red row and full yellow row" do
      before do
        7.times { |column| board.drop_token(:red, column) }
        7.times { |column| board.drop_token(:yellow, column) }
      end

      it "prints a grid with full red row and full yellow row" do
        text = get_text("spec/sample_grids/row-red-row-yellow.txt")
        expect { puts board.print }.to output(text).to_stdout
        # puts text
      end
    end
  end
end
