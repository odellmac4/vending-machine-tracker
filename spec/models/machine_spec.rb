require "rails_helper"

RSpec.describe Machine, type: :model do
  describe "validations" do
    it { should validate_presence_of :location }
    it { should belong_to :owner }
    it { should have_many :machine_snacks }
    it { should have_many(:snacks).through(:machine_snacks) }
  end

  describe "#snacks_avg_price" do
    before (:each) do
      
      owner = Owner.create(name: "Sam's Snacks")
      @dons  = owner.machines.create(location: "Don's Mixed Drinks")

      flamin_hots = @dons.snacks.create(name: "Flamin Hots", price: 1.50)
      oreos = @dons.snacks.create(name: "Oreos", price: 1.75)
      cheezits = @dons.snacks.create(name: "Cheezits", price: 2.75)
    end
    it 'calculates average price for all snacks in machine' do
      expect(@dons.snacks_avg_price).to eq(2)
    end
  end

  describe "#snack_count" do
    before (:each) do
      
      owner = Owner.create(name: "Sam's Snacks")
      @dons  = owner.machines.create(location: "Don's Mixed Drinks")

      flamin_hots = @dons.snacks.create(name: "Flamin Hots", price: 1.50)
      oreos = @dons.snacks.create(name: "Oreos", price: 1.75)
      cheezits = @dons.snacks.create(name: "Cheezits", price: 2.75)
    end
    it 'calculates average price for all snacks in machine' do
      expect(@dons.snack_count).to eq(3)
    end
  end
end
