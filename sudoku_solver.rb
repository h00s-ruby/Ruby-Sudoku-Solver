class SudokuSolver
  attr_reader :size

  def initialize()
    @size = 0
    @grid = Array.new
  end

  def load_from_file(file_path)
    File.open(file_path, 'r').each_line do |line|
      @grid.push(
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
    # TODO: determine correct size
    @size = 2
  end

  def value_allowed?(value, row, column)
    return false unless @grid[row].select {|cell| value == cell.value}.empty?
    return false unless @grid.transpose[column].select {|cell| value == cell.value}.empty?
    start_column = column - (column % @size)
    start_row = row - (row % @size)
    @grid[start_row..start_row+@size-1].each do |row_to_check|
      return false unless row_to_check[start_column..start_column+@size-1].select {|cell| value == cell.value}.empty?
    end
    true
  end

  def to_s
    output = ''
    @grid.each do |row|
      output += row.collect {|column| column.to_s}.join(' ') + "\n"
    end
    output
  end

  class Cell
    attr_accessor :value
    attr_reader :predefined

    def initialize(value, predefined = false)
      @value = value
      @predefined = predefined
    end

    def empty?
      @value.nil? ? true : false
    end

    def to_s
      empty? ? '?' : value
    end
  end

end

sudoku = SudokuSolver.new
sudoku.load_from_file('sudoku.txt')
puts sudoku.value_allowed? 2, 2, 1