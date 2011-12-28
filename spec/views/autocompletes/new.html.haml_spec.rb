require 'spec_helper'

describe "autocompletes/new.html.haml" do
  before(:each) do
    assign(:autocomplete, stub_model(Autocomplete,
      :find => "MyString",
      :near => "MyString"
    ).as_new_record)
  end

  it "renders new autocomplete form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => autocompletes_path, :method => "post" do
      assert_select "input#autocomplete_find", :name => "autocomplete[find]"
      assert_select "input#autocomplete_near", :name => "autocomplete[near]"
    end
  end
end
