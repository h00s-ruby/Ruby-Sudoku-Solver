# The program loads sudoku puzzle from file then
# it tries to solve using various solving algorithms.
# First algorithm is the simplest: brute force
#
# Author::    Krunoslav Husak  (mailto:krunoslav.husak@gmail.com)
# Copyright:: Copyright (c) 2011 Krunoslav Husak
# License::   Distributes under the same terms as Ruby

# This class implements algorithms for solving sudoku puzzle.
# Constructor requries one argument: path to textual file containing sudoku puzzle.
# Sudoku can be any size (4x4, 9x9, 25x25, ...)
# Cells where value is unknows should be 0. Example for file contents:
# 0 0 1 0
# 0 2 0 0
# 3 0 0 0
# 0 0 0 1

class SudokuSolver
  attr_reader :grid

  def initialize(sudoku_file_path)
    @grid = Grid.new
    @grid.load_from_file(sudoku_file_path)
  end

  def solve_brute_force
    @grid.move_to_first_cell
    cell = @grid.next_cell
    until cell.nil?
      if cell_value = cell.increment
        if @grid.value_allowed? (@grid.counter-1) / @grid.size.to_i, (@grid.counter-1) % @grid.size.to_i, cell_value
          cell.increment!
          cell = @grid.next_cell
        else
          cell.increment!
        end
      else
        cell.empty!
        cell = @grid.previous_cell
      end
    end
  end

  # Class implements methods for easier manipulation with grid
  class Grid
    attr_reader :size
    attr_reader :sub_size
    attr_reader :counter

    def initialize
      @rows = Array.new
      @counter = 0
    end

    # Returns row as array at specified row index (starting from zero)
    def row_at(row_index)
      @rows[row_index]
    end

    # Returns column as array at specified column index (starting from zero)
    def column_at(column_index)
      @rows.transpose[column_index]
    end

    def load_from_file(file_path)
      File.open(file_path, 'r').each_line do |line|
        @rows.push(
            line.split.collect do |value|
              value = value.to_i
              if value > 0
                Cell.new(value, true)
              else
                Cell.new(nil)
              end
            end
        )
      end
      @size = @rows.count
      @sub_size = Math.sqrt(@size)
    end

    def move_to_first_cell
      @counter = 0
    end

    def next_cell
      @rows.flatten[@counter..-1].each do |cell|
        @counter = @counter.next
        return cell unless cell.predefined?
      end
      nil
    end

    def previous_cell
      @rows.flatten[0..@counter-2].reverse.each do |cell|
        @counter = @counter.pred
        return cell unless cell.predefined?
      end
      nil
    end

    def current_cell_value_allowed?
      row = @counter / @sub_size.to_i
      column = @counter % @sub_size.to_i
      value_allowed? row, column, @rows[row][column].value
    end

    def value_allowed?(row_index, column_index, value)
      return false if row_contains_value?(row_index, value)
      return false if column_contains_value?(column_index, value)
      return false if subgrid_contains_value?(row_index, column_index, value)
      true
    end

    def cells_contains_value?(cells, value)
      return true unless cells.select { |cell| value == cell.value }.empty?
      false
    end

    def row_contains_value?(row_index, value)
      return true if cells_contains_value?(row_at(row_index), value)
      false
    end

    def column_contains_value?(column_index, value)
      return true if cells_contains_value?(column_at(column_index), value)
      false
    end

    def subgrid_contains_value?(row_index, column_index, value)
      start_row_index = row_index - (row_index % @sub_size)
      start_column_index = column_index - (column_index % @sub_size)
      end_row_index = start_row_index + @sub_size - 1
      end_column_index = start_column_index + @sub_size - 1
      @rows[start_row_index..end_row_index].each do |row|
        return true if cells_contains_value?(row[start_column_index..end_column_index], value)
      end
      false
    end

    def to_s
      output = ''
      @rows.each do |row|
        output += row.collect { |column| column.to_s }.join(' ') + "\n"
      end
      output
    end

    # Class represents one cell in sudoku grid
    class Cell
      attr_accessor :value
      attr_reader :predefined

      def initialize(value, predefined = false)
        @value = value
        @predefined = predefined
      end

      def predefined?
        @predefined
      end

      def empty?
        @value.nil? ? true : false
      end

      def empty!
        @value = nil
      end

      def to_s
        empty? ? '?' : @value.to_s
      end

      def increment
        if empty?
          1
        else
          if @value == 9
            false
          else
            @value.next
          end
        end
      end

      def increment!
        @value = self.increment
      end
    end

  end

end

sudoku = SudokuSolver.new('sudoku.txt')
sudoku.solve_brute_force
puts sudoku.grid.to_s
