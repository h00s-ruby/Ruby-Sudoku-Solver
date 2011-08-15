class SudokuSolver
  attr_reader :size

  def initialize()
    @size = 0
    @matrix = Array.new
  end

  def load_from_file(file_path)
    File.open(file_path, 'r').each_line do |line|
      @matrix.push(
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
    @size = @matrix.count
  end

  def to_s
    output = ''
    @matrix.each do |row|
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
puts sudoku.to_s
