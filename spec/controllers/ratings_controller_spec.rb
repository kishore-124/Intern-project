require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  describe 'POST #create' do
    context 'positive cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com',password:'9047446861')
        sign_in(user)
        topic = Topic.create(title: 'Anything')
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        postq = topic.posts.create!(name: 'post' , description: 'kk', user_id: user.id,avatar: file)

        post :create, params: { rating: { star: 1 }, topic_id: topic.id,post_id: postq.id }
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
      end
      it 'returns a redirect status' do
        expect(response.status).to eq(302)
      end
      it 'returns a redirect path' do
        user = User.create(email: 'kishore@mallow-tech1.com',password:'9047446861')
        sign_in(user)
        topic = Topic.create(title: 'Anything')
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        postq = topic.posts.create(name: 'post' , description: 'kk',user_id: user.id,avatar: file)
        post :create, params: { rating: { star: 1 }, topic_id: topic.id ,post_id: postq.id }
        expect(response).to redirect_to(topic_post_path(id: postq.id))
      end
      it 'Notifies a flash save' do
        expect(flash[:notice]).to eq('Ratings added successfully')
      end
    end

  end

end
