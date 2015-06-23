require 'spec_helper'

describe Occupation do
  it { should have_many(:characters) }
  it { should validate_uniqueness_of(:name) }
end
