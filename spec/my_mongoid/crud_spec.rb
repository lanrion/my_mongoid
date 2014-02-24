require "spec_helper"

class Event
  include MyMongoid::Document
  field :public
  field :created_at, :type => Time
  field :age, :default => "12"
end

describe "MyMongoid::Creatable" do
  let(:attrs){
    {"public" => true, "created_at" => Time.now}
  }

  let(:event){
    Event.new(attrs)
  }

  it "save a Event instance" do
    event.save
    expect(event.new_record?).to eq false
  end

  it "create a Event" do
    event = Event.create(attrs)
    expect(event.new_record?).to eq false
  end

  it "delete a Event instance" do
    event_1 = Event.create(attrs)
    event_1.remove
  end

  it "delete all events" do
    expect(Event.count).not_to eq 0
    Event.delete_all
    expect(Event.count).to eq 0
  end

  it "test find_by_attr_name method" do
    event.save
    event_1 = Event.find_by("public" => true)
    expect(event_1.class).to eq Event
    expect(event_1.id).to eq event.id
  end

  it "Event should new a empty attrs" do
    event = Event.new
    expect(event.class).to eq Event
  end

  # TODO: replace self, not using moped directly
  # it "update" do
  #   event_1 = Event.new(:age => "27")
  #   expect(event.new_record?).to eq true
  #   event_1.save
  #   expect(event_1.new_record?).to eq false

  #   event_2 = Event.find_by("id" => event_1.id)
  #   event_2.age = "20"
  #   event_2.save
  #   expect(event.age).not_to eq "27"

  # end
end
