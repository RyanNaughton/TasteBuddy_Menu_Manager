require 'spec_helper'

describe MenuItem do
  describe 'search' do
    it 'matches by dish name' do
      curry, *others = [:green_curry, :spagetti, :hamburger, :pad_thai].map {|sym| Factory(sym) }
      
    end
  end
end
