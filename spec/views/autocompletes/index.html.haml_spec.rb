require 'spec_helper'

describe "autocompletes/index.html.haml" do
  before(:each) do
    assign(:autocompletes, [
      stub_model(Autocomplete,
        :find => "Find",
        :near => "Near"
      ),
      stub_model(Autocomplete,
        :find => "Find",
        :near => "Near"
      )
    ])
  end

  it "renders a list of autocompletes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Find".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Near".to_s, :count => 2
  end
end
