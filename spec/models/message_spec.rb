require 'rails_helper'

describe Message do
  let(:msg) { build(:message) }

  it "card" do
    msg.card(1, -1, true)
    msg.card(2, 7, false)
    msg.save

    expect(Message.count).to eq 1
    expect(msg).to_not be_sent
    expect(msg.json).to eq "{\"players\":[[1,-1,true],[2,7,false]]}"
  end

  it "disc" do
    msg.disc(-2)
    msg.save

    expect(Message.count).to eq 1
    expect(msg).to_not be_sent
    expect(msg.json).to eq "{\"disc\":-2}"
  end

  it "pack" do
    msg.pack(3, 12)
    msg.save

    expect(Message.count).to eq 1
    expect(msg).to_not be_sent
    expect(msg.json).to eq "{\"pack\":[3,12]}"
  end

  it "all" do
    msg.card(4, 7, true)
    msg.pack(11, 5)
    msg.disc(9)
    msg.save

    expect(Message.count).to eq 1
    expect(msg).to_not be_sent
    expect(msg.json).to eq "{\"players\":[[4,7,true]],\"pack\":[11,5],\"disc\":9}"
  end
end
