require 'spec_helper'

describe "characters/show" do
  before(:each) do
    @character = assign(:character, stub_model(Character,
      :name => "Name",
      :strength => 1,
      :dexterity => 2,
      :constitution => 3,
      :intelligence => 4,
      :wisdom => 5,
      :charisma => 6
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/6/)
  end
end
