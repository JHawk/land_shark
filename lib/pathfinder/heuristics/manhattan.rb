module Pathfinder
  module Heuristics
    class Manhattan

      def initialize(end_node, weight=1)
        @end_x = end_node[:x]
        @end_y = end_node[:y]
        @weight = weight
      end

      def h(node, weight=@weight)
        weight * ((node[:x] - @end_x).abs + (node[:y] - @end_y).abs)
      end
    end
  end
end

