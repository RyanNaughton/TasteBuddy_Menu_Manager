require 'spec_helper'

describe 'Pictures' do
  describe 'GET /pictures' do
    context 'when no pictures exist' do
      before do
        visit pictures_path
      end

      it 'explains that no pictures exist' do
        page.should have_content("No photos here. Why don't you add one?")
      end
    end

    context 'when pictures exist' do
      before do
        Factory(:picture)
        visit pictures_path
      end

      it 'displays pictures' do
        pending('correct capybara method for parsing non-textual data')
      end
    end
  end
end
