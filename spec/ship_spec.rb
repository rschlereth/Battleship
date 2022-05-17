require "pry"
require './lib/ship'

RSpec.describe Ship do
  before(:each) do
    @cruiser = Ship.new("Cruiser", 3)
  end

  it "exists" do
    expect(@cruiser).to be_instance_of(Ship)
  end

  it "has a name" do
    expect(@cruiser.name).to eq("Cruiser")
  end

  it "has a length" do
    expect(@cruiser.length).to eq(3)
  end

  # change name once code is created
  it "has health" do
    expect(@cruiser.health).to eq(3)
  end

  it "indicates if it has been sunk" do
    # binding.pry
    expect(@cruiser.sunk?).to eq(false)
  end

  it "has been hit once" do
    @cruiser.hit
    expect(@cruiser.health).to equal(2)
  end

  xit "has been hit twice" do
    2.times do @cruiser.hit end
    expect(@cruiser.health).to equal(1)
    expect(@cruiser.sunk?).to equal(false)
  end

  xit "has been hit three times" do
    3.times do @cruiser.hit end
    expect(@cruiser.health).to equal(0)
    expect(@cruiser.sunk?).to equal(true)
  end
end
