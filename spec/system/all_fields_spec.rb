require 'rails_helper'

RSpec.describe 'All Fields', type: :system do
  let!(:fields) do 
    3.times.map do |_|
      create(:field)
    end
  end

  subject do
    visit '/fields'
  end

  it 'shows the available fields' do
    subject
    fields.each do |field|
      element = find("[data-test-field-id='#{field.id}']")
      expect(element).to be_present
    end
  end

  context 'when there are no fields' do
    let!(:fields) { [] }

    it 'shows the no fields tip' do
      subject
      expect(page).to have_content('There are no fields yet.')
    end
  end
end
