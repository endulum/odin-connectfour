require_relative "../lib/grid"

describe Grid do
  subject(:grid) { described_class.new }

  describe "accessing a space on the grid" do
    context "when grid is empty" do
      it "is nil for every space" do
        7.times do |column|
          6.times do |column_position|
            value = grid.at_space(column, column_position)
            expect(value).to be nil
          end
        end
      end
    end
  end

  describe "dropping a token into a column" do
    token_color = "red"
    column = 0

    context "when a column is empty" do
      it "occupies first space in column" do
        expect { grid.drop_token(token_color, column) }
          .to change { grid.column(column) }
          .from([nil, nil, nil, nil, nil, nil])
          .to(["red", nil, nil, nil, nil, nil])
      end
    end

    context "when a column has a token" do
      subject(:grid_with_one_token) do
        grid = described_class.new
        grid.drop_token(token_color, column)
        return grid
      end

      it "occupies second space in column" do
        expect { grid_with_one_token.drop_token(token_color, column) }
          .to change { grid_with_one_token.column(column) }
          .from(["red", nil, nil, nil, nil, nil])
          .to(["red", "red", nil, nil, nil, nil])
      end
    end

    context "when a column is nearly full" do
      subject(:grid_with_five_tokens) do
        grid = described_class.new
        5.times { grid.drop_token(token_color, column) }
        return grid
      end

      it "occupies last space in column" do
        expect { grid_with_five_tokens.drop_token(token_color, column) }
          .to change { grid_with_five_tokens.column(column) }
          .from(["red", "red", "red", "red", "red", nil])
          .to(%w[red red red red red red])
      end
    end

    context "when a column is full" do
      subject(:grid_with_full_column) do
        grid = described_class.new
        6.times { grid.drop_token(token_color, column) }
        return grid
      end

      it "does nothing to column" do
        expect { grid_with_full_column.drop_token(token_color, column) }
          .not_to(change { grid_with_full_column.column(column) })
      end
    end
  end

  describe "determining if column is full" do
    column = 0

    context "when column is empty" do
      it "is not full" do
        expect(grid.column_full?(0)).to be false
      end
    end

    context "when column is nearly full" do
      subject(:grid_with_partial_column) do
        grid = described_class.new
        5.times { grid.drop_token("red", column) }
        return grid
      end

      it "is not full" do
        expect(grid_with_partial_column.column_full?(0)).to be false
      end
    end

    context "when column is full" do
      subject(:grid_with_full_column) do
        grid = described_class.new
        6.times { grid.drop_token("red", column) }
        return grid
      end

      it "is full" do
        expect(grid_with_full_column.column_full?(0)).to be true
      end
    end
  end

  describe "printing the grid" do
    context "when grid is empty" do
      it "prints an empty grid" do
        text = ""
        File.open("spec/sample_grids/empty.txt") { |file| text = file.gets }
        expect(grid.print).to be text
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
        text = ""
        File.open("spec/sample_grids/one-red-one-yellow.txt") { |file| text = file.gets }
        expect(grid_with_tokens.print).to be text
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
        text = ""
        File.open("spec/sample_grids/col-red-col-yellow.txt") { |file| text = file.gets }
        expect(grid_with_columns.print).to be text
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
        text = ""
        File.open("spec/sample_grids/row-red-row-yellow.txt") { |file| text = file.gets }
        expect(grid_with_rows.print).to be text
      end
    end
  end
end
