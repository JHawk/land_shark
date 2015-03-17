require 'spec_helper'

describe "occupations/edit" do
  before(:each) do
    @occupation = assign(:occupation, stub_model(Occupation,
      :name => "MyString"
    ))
  end

  it "renders the edit occupation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", occupation_path(@occupation), "post" do
      assert_select "input#occupation_name[name=?]", "occupation[name]"
    end
  end
end
