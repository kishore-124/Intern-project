require 'rails_helper'
RSpec.describe Topic, type: :model do
    subject {Topic.new}
    it "is not valid without a tittle" do
      expect(subject).not_to be_valid
    end
    it "is  valid with a tittle" do
      subject.title = "Anything"
      expect(subject).to be_valid
    end
end
