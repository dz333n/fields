require 'rails_helper'

RSpec.describe 'Delete Field', type: :system, js: true do
  let(:field) { create(:field) }

  subject do
    visit "/fields/#{field.id}"
    # FIXME: for some reason clicking does not work instantly
    #        (actually only 2 times click is required for confirming deletion)
    10.times do
      selector = '#delete-field-button'
      break unless page.has_css?(selector) 
      find(selector).click
    end
  end

  it 'deletes the field from the database' do
    subject
    expect(Field.find_by(id: field.id)).to be_nil
  end
end
