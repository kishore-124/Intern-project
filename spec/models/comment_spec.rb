require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is not valid without a name' do
    user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
    topic = Topic.create(title: 'kishore',user_id:user.id)
    file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
    post = topic.posts.create(name: 'huiopoi',description: 'obioj',user_id:user.id,avatar:file)
    comment = post.comments.create( comment: '',user_id:user.id)
    expect(comment).not_to be_valid
  end

  it { should belong_to(:post) }
end
