require 'spec_helper'

describe "autocompletes/edit.html.haml" do
  before(:each) do
    @autocomplete = assign(:autocomplete, stub_model(Autocomplete,
      :find => "MyString",
      :near => "MyString"
    ))
  end

  it "renders the edit autocomplete form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => autocompletes_path(@autocomplete), :method => "post" do
      assert_select "input#autocomplete_find", :name => "autocomplete[find]"
      assert_select "input#autocomplete_near", :name => "autocomplete[near]"
    end
  end
end
