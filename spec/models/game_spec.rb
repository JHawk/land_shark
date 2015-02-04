require 'spec_helper'

describe Game do
  it { should belong_to(:user) }

  it { should validate_presence_of(:user) }
end

