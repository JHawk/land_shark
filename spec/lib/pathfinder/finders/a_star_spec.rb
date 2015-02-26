require 'spec_helper'
require 'pathfinder/finders/a_star'

describe Pathfinder::Finders::AStar do
  let(:a_star) { Pathfinder::Finders::AStar.new }

  describe "#grid" do
    describe "#visited_positions" do
      let(:closed) { {:x=>0, :y=>0, :f=>0, :g=>0, :h=>nil, :opened=>true, :closed=>true} }
      let(:opened) { {:x=>0, :y=>0, :f=>0, :g=>0, :h=>nil, :opened=>true} }
      let(:not_visited) { {:x=>0, :y=>0, :f=>0, :g=>0, :h=>nil} }

      let(:grid) do
        {
          :max_x => 10,
          :max_y => 10,

          [0,0] => closed,
          [0,1] => opened,
          [0,2] => not_visited
        }
      end

      before do
        a_star.current_grid = grid
      end

      subject { a_star.visited_positions }

      it { should include(closed) }
      it { should include(opened) }
      it { should_not include(not_visited) }
    end
  end

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

      context 'origin to 2,2' do
        let(:position1) { {x: 0, y: 0} }
        let(:position2) { {x: 2, y: 2} }
        let(:grid) { {max_x:5, max_y:5} }

        it { should include([0,0]) }
        it { should include([2,2]) }
        it { subject.length.should eq(5) }
      end

      context 'obstructed paths' do
        context '1' do
          #
          #
          #    |
          # 1  |  2
          #    |
          #
          #


          let(:grid) {
            a_star.grid_from_s_map(<<-G)
........
...........
...........
...........
....|......
.1..|..2...
....|......
..........
...........
            G
          }

          let(:position1) { {x: 1, y: 3} }
          let(:position2) { {x: 7, y: 3} }
          let(:grid2) {
            {
              max_x:10,
              max_y:10,

              [4,2] => { walkable: false },
              [4,3] => { walkable: false },
              [4,4] => { walkable: false }
            }
          }

          it { should include([1,3]) }
          it { should include([7,3]) }

          it { should_not include([4,2]) }
          it { should_not include([4,3]) }
          it { should_not include([4,4]) }

          it { subject.length.should eq(11) }

          it 'should only visit necessary positions' do
            subject

            expect(a_star.current_grid).not_to be_nil
            expect(a_star.visited_positions.count).to eq(31)
          end
        end

        context '2' do
        end
      end
    end
  end
end

