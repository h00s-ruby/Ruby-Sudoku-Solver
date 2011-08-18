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

  def initialize()
    @grid = Grid.new()
  end

  def solve_brute_force
    cell_index = 0
    cell = @grid.cell_at(cell_index)
    while cell_index < (@grid.size * @grid.size)
      if cell_value = cell.increment
        if @grid.value_allowed? cell_index, cell_value
          cell.increment!
          (cell_index+1..(@grid.size*@grid.size)).each do |index|
            next if @grid.cell_at(index).predefined?
            cell_index = index
            cell = @grid.cell_at(cell_index)
            break
          end
        end
        cell.increment!
      else
        cell.empty!
        (0..cell_index-1).reverse_each do |index|
          next if @grid.cell_at(index).predefined?
          cell_index = index
          cell = @grid.cell_at(cell_index)
          break
        end
      end
    end
  end

  # Class implements methods for easier manipulation with grid
  class Grid
    attr_reader :size
    attr_reader :sub_size

    def initialize()
      @size = 0
      @sub_size = 0
      @rows = Array.new
    end

    def [](row_index, column_index)
      @rows[row_index][column_index]
    end

    def cell_at(cell_index)
      @rows[cell_index / @size.to_i][cell_index % @size.to_i]
    end

    def load_from_file(file_path)
      File.open(file_path, 'r').each_line do |line|
        @rows.push(
            line.split.collect do |value|
              value = value.to_i
              if value > 0
                Cell.new(value, 9, true)
              else
                Cell.new(nil, 9)
              end
            end
        )
      end
      @size = @rows.count
      @sub_size = Math.sqrt(@size)
    end

    def value_allowed?(cell_index, value)
      row_index = cell_index / @size.to_i
      column_index = cell_index % @size.to_i
      return false if row_contains_value?(row_index, value)
      return false if column_contains_value?(column_index, value)
      return false if subgrid_contains_value?(row_index, column_index, value)
      true
    end

    def row_contains_value?(row_index, value)
      (0..@size-1).each do |column_index|
        return true if @rows[row_index][column_index].value == value
      end
      false
    end

    def column_contains_value?(column_index, value)
      (0..@size-1).each do |row_index|
        return true if @rows[row_index][column_index].value == value
      end
      false
    end

    def subgrid_contains_value?(row_index, column_index, value)
      start_row_index = row_index - (row_index % @sub_size)
      start_column_index = column_index - (column_index % @sub_size)
      end_row_index = start_row_index + @sub_size - 1
      end_column_index = start_column_index + @sub_size - 1
      @rows[start_row_index..end_row_index].each do |row|
        row[start_column_index..end_column_index].each do |cell|
          return true if cell.value == value
        end
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

      def initialize(value, max_value = 9, predefined = false)
        @max_value = max_value
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
          if @value == @max_value
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

sudoku = SudokuSolver.new()
sudoku.grid.load_from_file('sudoku.txt')
sudoku.solve_brute_force
puts sudoku.grid.to_s
