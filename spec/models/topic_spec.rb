require 'rails_helper'
RSpec.describe Topic, type: :model do
  it 'is not valid without a tittle' do
    user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
    topic =  Topic.create(title: '',user_id:user.id)
    expect(topic).not_to be_valid
  end
  it 'is  valid with a tittle' do
    user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
    topic = Topic.create(title: 'Anything',user_id:user.id)
    expect(topic).to be_valid
  end
end
