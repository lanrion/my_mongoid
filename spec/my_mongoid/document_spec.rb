require "spec_helper"

describe MyMongoid::Document do
  it "is a module" do
    expect(MyMongoid::Document).to be_a(Module)
  end
end

describe "Create a model:" do
  describe Event do
    it "is a mongoid model" do
      expect(Event.is_mongoid_model?).to eq(true)
    end
  end

  describe MyMongoid do
    it "maintains a list of models" do
      expect(MyMongoid.models).to include(Event)
    end
  end
end
