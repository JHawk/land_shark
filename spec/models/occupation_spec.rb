require 'spec_helper'

describe Occupation do
  it { should have_many(:characters) }
end
