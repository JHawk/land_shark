require 'spec_helper'
require 'pathfinder/finders/a_star'

describe Pathfinder::Finders::AStar do
  let(:a_star) { Pathfinder::Finders::AStar.new }

  describe "#find_path" do

    subject { a_star.find_path_a(position1, position2, grid) }

    context 'no diagonals' do
      context 'origin to origin' do
        let(:position1) { {x: 0, y: 0} }
        let(:position2) { {x: 0, y: 0} }
        let(:grid) { {max_x:10, max_y:10} }

        it { should eq([[0,0]]) }
      end

      context 'origin to 1,1' do
        let(:position1) { {x: 0, y: 0} }
        let(:position2) { {x: 1, y: 1} }

        context "when grid is nil" do
          let(:grid) { nil }

          it { should eq([[0,0]]) }
        end

        context "when grid contains start and end" do
          let(:grid) { {max_x:2, max_y:2} }

          it { should eq([[0,0],[0,1],[1,1]]) }
        end
      end
    end
  end
end

