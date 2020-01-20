require 'rails_helper'
RSpec.describe Article  do
  subject {Article.new}
  it "is not valid without a tittle" do
    expect(subject).not_to be_valid
  end
  it "is  valid with a tittle" do
    subject.title = "Anything"
    expect(subject).to be_valid
  end
  it "is  valid with a title and text" do
    subject.title = "Anything"
    subject.text = "Anything"
    expect(subject).to be_valid
  end
  it "is  valid with a text" do
    subject.text = nil
    expect(subject).to_not be_valid
  end
end