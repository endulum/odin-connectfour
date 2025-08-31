require_relative "../lib/grid"

describe Grid do
  subject(:grid) { described_class.new(4, 4) }

  describe "#set_value_at" do
    it "sets a value using x,y coordinates" do
      grid.column_count.times do |col|
        grid.row_count.times do |row|
          grid.set_value_at(col, row, :color)
        end
      end

      grid.column_count.times do |col|
        grid.row_count.times do |row|
          expect(grid.at(col, row)).to eq :color
        end
      end
    end
  end

  describe "#each" do
    before do
      grid.column_count.times do |col|
        grid.row_count.times do |row|
          grid.set_value_at(col, row, :color)
        end
      end
    end

    it "iterates through each cell in the grid" do
      values = grid.map
      expect(values).to eq Array.new(16).fill(:color)
    end
  end

  describe "axial enumerables" do
    subject(:grid) do
      grid = described_class.new(4, 4)
      grid.column_count.times do |col|
        # horizontally "striping" the grid with colors
        color = if col % 3 == 0
                  :blue
                else
                  col.even? ? :red : :yellow
                end
        grid.row_count.times do |row|
          grid.set_value_at(col, row, color)
        end
      end
      return grid
    end

    describe "#each_column" do
      it "iterates through columns of the grid" do
        columns = []
        expected_columns = [
          [:blue] * 4,
          [:yellow] * 4,
          [:red] * 4,
          [:blue] * 4
        ]

        grid.each_column { |column| columns.push(column) }
        expect(columns).to eq expected_columns
      end
    end

    describe "#each_row" do
      it "iterates through rows of the grid" do
        rows = []
        expected_rows = [%i[blue yellow red blue]] * 4

        grid.each_row { |row| rows.push(row) }
        expect(rows).to eq expected_rows
      end
    end
  end

  describe "#match_at?" do
    describe "horizontal matching" do
      subject(:grid) do
        grid = described_class.new(4, 4)
        # horizontal row of three
        grid.set_value_at(0, 0, :red)
        grid.set_value_at(1, 0, :red)
        grid.set_value_at(2, 0, :red)
        return grid
      end

      it "matches" do
        expect { grid.set_value_at(3, 0, :red) }
          .to change { grid.match_at?([0, 0], :red, 4) }
          .from(false)
          .to(true)
      end
    end

    describe "vertical matching" do
      subject(:grid) do
        grid = described_class.new(4, 4)
        # vertical row of three
        grid.set_value_at(0, 0, :red)
        grid.set_value_at(0, 1, :red)
        grid.set_value_at(0, 2, :red)
        return grid
      end

      it "matches" do
        expect { grid.set_value_at(0, 3, :red) }
          .to change { grid.match_at?([0, 0], :red, 4) }
          .from(false)
          .to(true)
      end
    end

    describe "forward-diagonal matching" do
      subject(:grid) do
        grid = described_class.new(4, 4)
        # forward diagonal row of three
        grid.set_value_at(0, 0, :red)
        grid.set_value_at(1, 1, :red)
        grid.set_value_at(2, 2, :red)
        return grid
      end

      it "matches" do
        expect { grid.set_value_at(3, 3, :red) }
          .to change { grid.match_at?([0, 0], :red, 4) }
          .from(false)
          .to(true)
      end
    end

    describe "backward-diagonal matching" do
      subject(:grid) do
        grid = described_class.new(4, 4)
        # backward diagonal row of three
        grid.set_value_at(0, 3, :red)
        grid.set_value_at(1, 2, :red)
        grid.set_value_at(2, 1, :red)
        return grid
      end

      it "matches" do
        expect { grid.set_value_at(3, 0, :red) }
          .to change { grid.match_at?([0, 3], :red, 4) }
          .from(false)
          .to(true)
      end
    end
  end
end
