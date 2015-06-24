require 'spec_helper'

describe Relationship do
  it 'has a valid factory' do
    expect(build(:relationship)).to be_valid
  end

  it { should belong_to(:character) }

  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:character) }
  it { should validate_presence_of(:acquaintance) }

end
