require 'pathfinder/heuristics/manhattan'

module Pathfinder
  module Finders
    class AStar
      attr_reader :allow_diagonal

      def initialize(opts={})
        @allow_diagonal = opts[:allow_diagonal] || false
        @heuristic = opts[:heuristic] || Heuristics::Manhattan
#        @diagonal_movement = opts[:diagonal_movement]
        @weight = opts[:weight] || 1;
      end

      # look at 
      # https://github.com/qiao/PathFinding.js/blob/master/src/finders/AStarFinder.js
      # A*
      # requires x & y
      # node = g, f, h, x, y, opened, closed, parent
      #
      # extract a grid class
      def find_path(start_node, end_node, grid)
        if grid.nil?
          [start_node]
        else
          _grid = grid.clone
          _max_x = grid[:max_x]
          _max_y = grid[:max_y]

          raise 'max_x & max_y required' unless _max_x && _max_y

          _start_node = start_node.clone
          _end_node = end_node.clone

          heuristic = @heuristic.new(_end_node, @weight)

          _start_node[:f] = 0   # sum of g and h
          _start_node[:g] = 0   # steps to start node
          _start_node[:h] = nil # steps to end node
          _start_node[:opened] = true

          open = []
          open.push _start_node

          while open.present? do
            _current_node = open.pop
            puts _current_node

            _current_node[:closed] = true
            _grid[node_to_a(_current_node)] = _current_node

            if node_to_a(_current_node) == node_to_a(_end_node)
              return final_path(_grid, _current_node)
            end

            new_g = _current_node[:g] + 1

            x = _current_node[:x]
            y = _current_node[:y]

            neighbors = []

            neighbors << [x-1, y] if x > 0
            neighbors << [x, y-1] if y > 0
            neighbors << [x+1, y] if x < _max_x-1
            neighbors << [x, y+1] if y < _max_y-1

            _neighbors = neighbors.map do |position|
              _grid[position] ||=
                {
                  x: position.first,
                  y: position.second,
                  closed: false,
                  opened: false
                }
            end

            _neighbors.each do |neighbor|
              if (!neighbor[:opened] || new_g < neighbor[:g])
                neighbor[:g] = new_g
                neighbor[:h] ||= heuristic.h(neighbor)
                neighbor[:f] = neighbor[:g] + neighbor[:h]
                neighbor[:parent] = node_to_a(_current_node)

                if (!neighbor[:opened])
                  open.push neighbor
                  neighbor[:opened] = true
                else
                  # ???
                  binding.pry
                end
              end
            end
          end
        end
      end

      def final_path(_grid, _end_node)
        path = [_end_node]
        _current_node = _end_node

        while _current_node[:parent] do
          parent_position = _current_node[:parent]
          parent_node = _grid[parent_position]
          path << parent_node
          _current_node = parent_node
        end

        path.reverse
      end

      def find_path_a(start_node, end_node, grid)
        find_path(start_node, end_node, grid).map do |node|
          node_to_a(node)
        end
      end

      def node_to_a(node)
        [node[:x], node[:y]]
      end
    end
  end
end

