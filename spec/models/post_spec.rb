require 'rails_helper'
RSpec.describe Post, type: :model do
  it "is not valid without a name and description" do
    topic= Topic.create(title: "kishore")
    post=topic.posts.create(name:"",description:"")
    expect(post).not_to  be_valid

  end
  it "is  valid with a name and description" do
    topic= Topic.create(title: "kishore")
    post=topic.posts.create(name:"kkk",description:"km")
    expect(post).to be_valid
  end
  it { should validate_presence_of(:name)}
end

