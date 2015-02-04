require 'spec_helper'

describe "characters/new" do
  before(:each) do
    assign(:character, stub_model(Character,
      :name => "MyString",
      :strength => 1,
      :dexterity => 1,
      :constitution => 1,
      :intelligence => 1,
      :wisdom => 1,
      :charisma => 1
    ).as_new_record)
  end

  it "renders new character form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", characters_path, "post" do
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
