module Positionable
  class << self
    def included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      def position_a
        [x,y,z]
      end

      def position
        {x:x,y:y,z:z}
      end
    end

    module ClassMethods
    end
  end
end

