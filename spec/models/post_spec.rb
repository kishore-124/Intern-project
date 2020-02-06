require 'rails_helper'
RSpec.describe Post, type: :model do
  it "is not valid without a name and description" do
    topic= Topic.create(title: "kishore")
    post=topic.posts.create(name:"",description:"")
    expect(post).not_to  be_valid

  end
  it "is  valid with a name and description" do
    user = User.create(email: 'kishore@mallow-tech.com',password:'9047446861')
    topic= Topic.create(title: "kishore")
    post=topic.posts.create!(name:"kkk",description:"km",user_id: user.id)
    expect(post).to be_valid
  end
  it { should validate_presence_of(:name)}

  it { should accept_nested_attributes_for(:tags) }

  it { should belong_to(:topic) }
end

