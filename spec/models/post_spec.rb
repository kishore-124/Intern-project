require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:avatar) }
  it { should accept_nested_attributes_for(:tags) }

  it { should belong_to(:topic) }

end
