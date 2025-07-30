require_relative "../lib/grid"

describe Grid do
  subject(:grid) { described_class.new }

  describe "accessing grid info" do
    context "when grid is empty" do
      it "is nil for every space" do
        grid.each { |cell| expect(cell).to be nil }
      end

      it "has columns of all nil" do
        grid.each_column do |column|
          expect(column).to eq [nil, nil, nil, nil, nil, nil]
        end
      end
    end
  end

  describe "dropping a token into a column" do
    color = :red
    column = 0

    context "when a column is empty" do
      it "occupies first space in column" do
        expect { grid.drop_token(color, column) }
          .to change { grid.at_column(column) }
          .from([nil, nil, nil, nil, nil, nil])
          .to([color, nil, nil, nil, nil, nil])
      end
    end

    context "when a column has a token" do
      subject(:grid_with_one_token) do
        grid = described_class.new
        grid.drop_token(color, column)
        return grid
      end

      it "occupies second space in column" do
        expect { grid_with_one_token.drop_token(color, column) }
          .to change { grid_with_one_token.at_column(column) }
          .from([color, nil, nil, nil, nil, nil])
          .to([color, color, nil, nil, nil, nil])
      end
    end

    context "when a column is nearly full" do
      subject(:grid_with_five_tokens) do
        grid = described_class.new
        5.times { grid.drop_token(color, column) }
        return grid
      end

      it "occupies last space in column" do
        expect { grid_with_five_tokens.drop_token(color, column) }
          .to change { grid_with_five_tokens.at_column(column) }
          .from([color, color, color, color, color, nil])
          .to([color, color, color, color, color, color])
      end
    end

    context "when a column is full" do
      subject(:grid_with_full_column) do
        grid = described_class.new
        6.times { grid.drop_token(color, column) }
        return grid
      end

      it "does nothing to column" do
        expect { grid_with_full_column.drop_token(color, column) }
          .not_to(change { grid_with_full_column.at_column(column) })
      end
    end

    context "when token is not a valid Colorize symbol" do
      it "does nothing to column" do
        expect { grid.drop_token("red", column) }
          .not_to(change { grid.at_column(column) })
      end
    end
  end

  describe "printing the grid" do
    def get_text(filename)
      text = File
             .read(filename)
             .strip
             .gsub("\\e", "\e")
             .gsub("\\n", "\n")
      text << "\n"
      text
    end

    context "when grid is empty" do
      it "prints an empty grid" do
        text = get_text("spec/sample_grids/empty.txt")
        expect { puts grid.print }.to output(text).to_stdout
        puts text
      end
    end

    context "when grid has one red token and one yellow token" do
      subject(:grid_with_tokens) do
        grid = described_class.new
        grid.drop_token(:red, 0)
        grid.drop_token(:yellow, grid.column_count - 1)
        return grid
      end

      it "prints a grid with one red token and one yellow token" do
        text = get_text("spec/sample_grids/one-red-one-yellow.txt")
        expect { puts grid_with_tokens.print }.to output(text).to_stdout
        puts text
      end
    end

    context "when grid has full red column and full yellow column" do
      subject(:grid_with_columns) do
        grid = described_class.new
        6.times { grid.drop_token(:red, 0) }
        6.times { grid.drop_token(:yellow, grid.column_count - 1) }
        return grid
      end

      it "prints a grid with full red column and full yellow column" do
        text = get_text("spec/sample_grids/col-red-col-yellow.txt")
        expect { puts grid_with_columns.print }.to output(text).to_stdout
        puts text
      end
    end

    context "when grid has full red row and full yellow row" do
      subject(:grid_with_rows) do
        grid = described_class.new
        grid.column_count.times { |column| grid.drop_token(:red, column) }
        grid.column_count.times { |column| grid.drop_token(:yellow, column) }
        return grid
      end

      it "prints a grid with full red row and full yellow row" do
        text = get_text("spec/sample_grids/row-red-row-yellow.txt")
        expect { puts grid_with_rows.print }.to output(text).to_stdout
        puts text
      end
    end
  end

  describe "determining winning move" do
    context "test grid #1" do
      it "should not win until there is a four-in-a-row" do
        moves = [
          [:red, 2],
          [:red, 3],
          [:red, 4],
          [:yellow, 2],
          [:red, 2],
          [:yellow, 2],
          [:yellow, 2]
        ]

        moves.each do |token, column|
          coords = grid.drop_token(token, column)
          expect(grid.winning_move?(coords, token)).to be false
        end

        puts grid.print

        coords = grid.drop_token(:red, 5)
        expect(grid.winning_move?(coords, :red)).to be true
      end
    end
  end
end
