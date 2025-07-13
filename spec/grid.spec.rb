require_relative "../lib/grid"

describe Grid do
  subject(:grid) { described_class.new }

  describe "accessing a space on the grid" do
    context "when grid is empty" do
      it "is nil for every space" do
        7.times do |column|
          6.times do |column_position|
            value = grid.at(column, column_position)
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
        grid.drop_token(token_color, column)
        first_column = grid.column(column)
        expect(first_column).to eq ["red", nil, nil, nil, nil, nil]
      end
    end

    context "when a column has a token" do
      subject(:grid_with_one_token) do
        grid = described_class.new
        grid.drop_token(token_color, column)
        return grid
      end

      it "occupies second space in column" do
        grid_with_one_token.drop_token(token_color, column)
        first_column = grid.column(column)
        expect(first_column).to eq ["red", "red", nil, nil, nil, nil]
      end
    end

    context "when a column is nearly full" do
      subject(:grid_with_five_tokens) do
        grid = described_class.new
        5.times { grid.drop_token(token_color, column) }
        return grid
      end

      it "occupies last space in column" do
        grid_with_five_tokens.drop_token(token_color, column)
        first_column = grid.column(column)
        expect(first_column).to eq %w[red red red red red red]
      end
    end

    context "when a column is full" do
      it "gives an error" do
        #
      end
    end
  end
end
