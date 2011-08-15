class SudokuSolver
  attr_reader :matrix

  def initialize()
    @size = 0
    @matrix = Array.new
  end

  def load(file_path)
    File.open(file_path, 'r').each_line do |line|
      @matrix.push(line.split)
    end
  end

  class Cell
    def initialize(value)

    end
  end

end

sudoku = SudokuSolver.new
sudoku.load('sudoku.txt')
puts sudoku.matrix.to_s