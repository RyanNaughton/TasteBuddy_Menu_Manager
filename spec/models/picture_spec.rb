require 'spec_helper'

describe Picture do
  before do
    @picture = Factory(:gadaffi)
  end

  it 'validates' do
    @picture.should be_valid
  end

  it 'saves' do
    proc { @picture.save! }.should_not raise_error
  end

  describe '#application_hash' do
    it 'generates URLs for photos on S3' do
      @picture.application_hash.keys.should eq(%w{id 80px 160px 300px}.map(&:to_sym))
    end
  end
end
