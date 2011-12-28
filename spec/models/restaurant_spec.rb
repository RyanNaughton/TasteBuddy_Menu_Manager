require 'spec_helper'

describe Restaurant do
  describe 'validation' do
    it 'requires a name' do
      Factory(:restaurant).should be_valid
      proc { Factory(:restaurant, :name => nil) }.should raise_error(Mongoid::Errors::Validations)
    end
  end
end
