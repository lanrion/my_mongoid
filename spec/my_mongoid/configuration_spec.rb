# Should be able to configure MyMongoid:
#   MyMongoid::Configuration
#     should be a singleton class
#     should have #host accessor
#     should have #database accessor
#   MyMongoid.configuration
#     should return the MyMongoid::Configuration singleton
#   MyMongoid.configure
#     should yield MyMongoid.configuration to a block

require "spec_helper"

describe "Should be able to configure MyMongoid" do

  let(:config){
    MyMongoid::Configuration.instance
  }

  describe MyMongoid::Configuration do

    it "should be a singleton class" do
      expect(MyMongoid::Configuration.included_modules).to include(Singleton)
    end

    it "should have #host accessor" do
      expect(config.respond_to?(:host)).to eq true
    end

    it "should have #database accessor" do
      expect(config.respond_to?(:database)).to eq true
    end
  end

  describe "MyMongoid.configuration" do

    it "should return the MyMongoid::Configuration singleton" do
      expect(MyMongoid.configuration).to eq config
    end
  end

  describe "MyMongoid.configure" do

    it "should yield MyMongoid.configuration to a block" do
      MyMongoid.configure do |c|
        c.host     = "localhost:27017"
        c.database = "my_mongoid"
      end
      expect(config.database).to eq "my_mongoid"
    end
  end

end
