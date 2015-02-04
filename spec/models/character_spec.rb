require 'spec_helper'

describe Character do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:strength) }
  it { should validate_presence_of(:dexterity) }
  it { should validate_presence_of(:constitution) }
  it { should validate_presence_of(:intelligence) }
  it { should validate_presence_of(:wisdom) }
  it { should validate_presence_of(:charisma) }
end

