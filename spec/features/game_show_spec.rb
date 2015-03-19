require 'spec_helper'

feature 'game show' do
  before do
    login_as test_user
  end

  describe 'game show' do
    scenario "when current location selected" do
      visit '/'

      click_link 'New Game'
      click_button('Create Game')

      pc = test_user.games.first.characters.where(is_pc: true).first
      expect(page).to have_content pc.name
    end
  end
end

