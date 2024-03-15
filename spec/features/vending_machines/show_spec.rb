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

  describe 'extension' do
    before (:each) do
      owner = Owner.create(name: "Sam's Snacks")
      @dons  = owner.machines.create(location: "Don's Mixed Drinks")
      @excons = owner.machines.create(location: "Excon's Quick Mart")

      @flamin_hots = Snack.create!(name: "Flamin Hots", price: 1.50)
      @oreos = Snack.create!(name: "Oreos", price: 1.75)
      cheezits = Snack.create!(name: "Cheezits", price: 2.75)

      @takis = Snack.create!(name: "Takis", price: 1.00)
      @pop_tart = Snack.create!(name: "Strawberry Pop Tart", price: 3.75)

      @excons.snacks << [@oreos, @flamin_hots, @pop_tart]
      @dons.snacks << [@oreos, @takis, @pop_tart]

      
    end
    it 'displays button to delete snack from a vending machine' do
      visit machine_path(@dons)
      # I see a button (or link) next to each snack that says "Remove Snack"
      within("#snack-#{@oreos.id}") do
        expect(page).to have_button("Remove Oreos")

        click_button "Remove Oreos"
        expect(current_path).to eq(machine_path(@dons))
      end
      
      within("#snack-#{@takis.id}") do
        expect(page).to have_button("Remove Takis")
      end

      within("#snack-#{@pop_tart.id}") do
        expect(page).to have_button("Remove Strawberry Pop Tart")
      end

      expect(page).to_not have_content("Oreos: $1.75")

      visit machine_path(@excons)

      within("#snack-#{@oreos.id}") do
        expect(page).to have_button("Remove Oreos")
        expect(page).to have_content("Oreos: $1.75")
      end

      within("#snack-#{@flamin_hots.id}") do
        expect(page).to have_button("Remove Flamin Hots")
      end
      
      within("#snack-#{@pop_tart.id}") do
        expect(page).to have_button("Remove Strawberry Pop Tart")
        
        click_button "Remove Strawberry Pop Tart"
        expect(current_path).to eq (machine_path(@excons))
      end
      expect(page).to_not have_content("Strawberry Pop Tart: $3.75")

      visit machine_path(@dons)

      expect(page).to have_content("Strawberry Pop Tart: $3.75")
      expect(page).to have_button("Remove Strawberry Pop Tart")
      # When I click that button,
      # I am redirected to this vending machine's show page
      # And I no longer see that snack listed on this page
      # And when I visit a different vending machine's show page that also has that snack
      
      # I still see that snack listed.
    end
  end
end
