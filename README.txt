Ruby Sudoku Solver
==================

The program loads sudoku puzzle from file then
it tries to solve using various solving algorithms.
First algorithm is the simplest: brute force

Author::    Krunoslav Husak  (mailto:krunoslav.husak@gmail.com)
Copyright:: Copyright (c) 2011 Krunoslav Husak
License::   Distributes under the same terms as Ruby

Main class (SudokuSolver) implements algorithms for solving sudoku puzzle.
Constructor requries one argument: path to textual file containing sudoku puzzle.
Sudoku can be any size (4x4, 9x9, 25x25, ...)

Cells where value is unknows should be 0. Example for file contents:
0 0 1 0
0 2 0 0
3 0 0 0
0 0 0 1
