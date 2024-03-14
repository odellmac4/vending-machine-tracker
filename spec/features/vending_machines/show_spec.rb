require 'rails_helper'

RSpec.describe 'When a user visits a vending machine show page', type: :feature do
  scenario 'they see the location of that machine' do
    owner = Owner.create(name: "Sam's Snacks")
    dons  = owner.machines.create(location: "Don's Mixed Drinks")

    visit machine_path(dons)

    expect(page).to have_content("Don's Mixed Drinks Vending Machine")
  end

  describe 'User story 1' do
    before (:each) do
      owner = Owner.create(name: "Sam's Snacks")
      dons  = owner.machines.create(location: "Don's Mixed Drinks")

      flamin_hots = dons.snacks.create(name: "Flamin Hots", price: 1.50)
      oreos = dons.snacks.create(name: "Oreos", price: 1.75)
      cheezits = dons.snacks.create(name: "Cheezits", price: 2.75)

      visit machine_path(dons)
    end
    it 'displays name of all snacks and its attributes' do
      # As a visitor
      # When I visit a vending machine show page
      # I see the name of all of the snacks associated with that vending machine along with their price
      expect(page).to have_content("Flamin Hots: $1.50")
      expect(page).to have_content("Oreos: $1.75")
      expect(page).to have_content("Cheezits: $2.75")
    end

    it 'displays average price for all snacks in machine' do
      # and I also see an average price for all of the snacks in that machine.
      expect(page).to have_content("Average Price: $2.00")
    end
  end

  describe 'User story 2' do
    before (:each) do
      owner = Owner.create(name: "Sam's Snacks")
      @dons  = owner.machines.create(location: "Don's Mixed Drinks")

      flamin_hots = @dons.snacks.create(name: "Flamin Hots", price: 1.50)
      oreos = @dons.snacks.create(name: "Oreos", price: 1.75)
      cheezits = @dons.snacks.create(name: "Cheezits", price: 2.75)

      @takis = Snack.create!(name: "Takis", price: 1.00)
      @pop_tart = Snack.create!(name: "Strawberry Pop Tart", price: 3.75)

      visit machine_path(@dons)
    end
    it 'displays a form to add existing snack in database by the id' do
      expect(page).to_not have_content("Takis: $1.00")
      expect(page).to_not have_content("Strawberry Pop Tart: $3.75")
      # I see a form to add an existing snack to that vending machine
      # When I fill in the form with the ID of a snack that already exists in the database
      fill_in "Snack id", with: "#{@takis.id}"
      # And I click Submit
      click_button "Submit"
      # Then I am redirected to that vending machine's show page
      expect(current_path).to eq(machine_path(@dons))
      # And I see that snack is now listed.
      expect(page).to have_content("Takis: $1.00")
    end
  end
end
