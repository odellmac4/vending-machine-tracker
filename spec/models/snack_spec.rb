require 'rails_helper'

RSpec.describe Snack, type: :model do
  describe "relationships" do
    it {should have_many(:machine_snacks)}
    it {should have_many(:machines).through(:machine_snacks)}
  end

  describe "#locations" do
    it 'retrieves a list of all its vending machine locations' do
      owner = Owner.create(name: "Sam's Snacks")

      vons  = owner.machines.create(location: "Von's Shopping")
      excons  = owner.machines.create(location: "Excon's Quick Mart")

      takis = Snack.create!(name: "Takis", price: 1.00)
      pop_tart = Snack.create!(name: "Strawberry Pop Tart", price: 3.75)

      vons.snacks << pop_tart
      excons.snacks << pop_tart

      expect(pop_tart.locations).to eq(["Von's Shopping", "Excon's Quick Mart"])
    end
  end
end
