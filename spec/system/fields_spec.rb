require 'rails_helper'

RSpec.describe 'All fields', type: :system do
  it 'shows the static text' do
    visit '/fields'
    expect(page).to have_content('Hello world')
  end
end