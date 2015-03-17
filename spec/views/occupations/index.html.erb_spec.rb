require 'spec_helper'

describe "occupations/index" do
  before(:each) do
    assign(:occupations, [
      stub_model(Occupation,
        :name => "Name"
      ),
      stub_model(Occupation,
        :name => "Name"
      )
    ])
  end

  it "renders a list of occupations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
