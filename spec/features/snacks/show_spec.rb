require 'rails_helper'

RSpec.describe 'Snacks show page' do
    describe 'User story 3' do
        before (:each) do
            owner = Owner.create(name: "Sam's Snacks")
            @dons  = owner.machines.create(location: "Don's Mixed Drinks")
            @vons  = owner.machines.create(location: "Von's Shopping")
            @excons  = owner.machines.create(location: "Excon's Quick Mart")

            flamin_hots = @excons.snacks.create(name: "Flamin Hots", price: 1.50)
            oreos = @vons.snacks.create(name: "Oreos", price: 1.75)
            cheezits = @excons.snacks.create(name: "Cheezits", price: 2.75)

            takis = Snack.create!(name: "Takis", price: 1.00)
            @pop_tart = Snack.create!(name: "Strawberry Pop Tart", price: 3.75)

            @vons.snacks << @pop_tart
            @excons.snacks << @pop_tart
        end

        it 'displays a snacks attributes' do
            # As a visitor
            # When I visit a snack show page
            visit snack_path(@pop_tart)
            # I see the name of that snack
            expect(page).to have_content("Strawberry Pop Tart")
            # and I see the price for that snack
            expect(page).to have_content("Price: $3.75")
        end

        it 'displays other vending machine locations and average prices for each vending machine the snack is located at' do
            visit snack_path(@pop_tart)
            # and I see a list of locations with vending machines that carry that snack
            # and I see the average price for snacks in those vending machines
            # and I see a count of the different kinds of items in that vending machine.
            within("#machine-#{@vons.id}") do
                expect(page).to have_content("Von's Shopping (2 kinds of snacks, average price of $2.75)")
            end
            
            within("#machine-#{@excons.id}") do
                expect(page).to have_content("Excon's Quick Mart (3 kinds of snacks, average price of $2.67)")
            end
            # ​Example: 

            # Flaming Hot Cheetos
            # Price: $2.50
            # Locations
            #     * Don's Mixed Drinks (3 kinds of snacks, average price of $2.50)
            #     * Turing Basement (2 kinds of snacks, average price of $3.00)
        end
    end
end