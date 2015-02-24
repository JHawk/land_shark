require 'spec_helper'
require 'timer'

describe Timer do
  let(:timed) { Class.new { include Timer }.new }

  describe "#time" do
    let(:result) { 'result' }

    context 'no args' do
      subject { timed.time('message') { result } }

      it { should eq(result) }
    end

    context 'one arg' do
      context 'when yielding the time' do
        it 'makes the start time available to the block' do
          start_time = nil

          timed.time('message') do |time|
            start_time = time
          end

          expect(start_time).to be_a(Time)
        end
      end
      context 'when returning the result' do
        subject do
          timed.time('message') do |time|
            result
          end
        end

        it { should eq(result) }
      end
    end
  end
end

