require 'spec_helper'

describe "autocompletes/show.html.haml" do
  before(:each) do
    @autocomplete = assign(:autocomplete, stub_model(Autocomplete,
      :find => "Find",
      :near => "Near"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Find/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Near/)
  end
end
