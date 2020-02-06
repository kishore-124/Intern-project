require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is not valid without a name' do
    topic = Topic.create(title: 'kishore')
    post = topic.posts.create(name: 'huiopoi',description: 'obioj')
    comment = post.comments.create(user: '', comment: 'kk')
    expect(comment).not_to be_valid
  end

  it { should validate_presence_of(:user) }
  it { should belong_to(:post) }
end
