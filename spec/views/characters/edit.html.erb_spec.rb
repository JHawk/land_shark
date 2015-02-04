require 'spec_helper'

describe "characters/edit" do
  before(:each) do
    @character = assign(:character, stub_model(Character,
      :name => "MyString",
      :strength => 1,
      :dexterity => 1,
      :constitution => 1,
      :intelligence => 1,
      :wisdom => 1,
      :charisma => 1
    ))
  end

  it "renders the edit character form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", character_path(@character), "post" do
      assert_select "input#character_name[name=?]", "character[name]"
      assert_select "input#character_strength[name=?]", "character[strength]"
      assert_select "input#character_dexterity[name=?]", "character[dexterity]"
      assert_select "input#character_constitution[name=?]", "character[constitution]"
      assert_select "input#character_intelligence[name=?]", "character[intelligence]"
      assert_select "input#character_wisdom[name=?]", "character[wisdom]"
      assert_select "input#character_charisma[name=?]", "character[charisma]"
    end
  end
end
