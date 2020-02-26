# frozen_string_literal: true
require 'rails_helper'
RSpec.describe PostsController, type: :controller do
  describe 'GET #index' do
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      get :index, params: { user_id: user.id }
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a rendered template type' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('index')
    end
    it 'assigns @posts' do
      user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'anything', user_id: user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      expect(assigns(:posts)).to eq([post])
    end
    it 'checks the pagination limit value' do
      expect(assigns(:posts).limit_value).to eq(10)
    end
    it 'Checks the Page offset correctly' do
      user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
      user.confirm
      sign_in(user)
      1.upto(34) do
        topic = Topic.create(title: 'Anything', user_id: user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      end
      get :index, params: { page: 4 }
      expect(assigns[:posts].map(&:id).count).to eq(4)
    end
  end
  describe 'GET #show' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create!(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      get :show, params: { id: post.id, topic_id: topic.id }
    end
    it 'returns a content type' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('show')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns the value of the instance' do
      user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
      user.confirm
      topic = Topic.create(title: 'anything', user_id: user.id)
      sign_in(user)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create!(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      get :show, params: { id: post.id, topic_id: topic.id }
      expect(assigns(:post)).to eq(post)
    end
    it 'returns a content in page' do
      expect(response.body).to match('post')
    end

  end

  describe 'GET #edit' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      post = topic.posts.create!(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      get :edit, params: { id: post.id, topic_id: topic.id }
    end
    it 'returns a content type of the page' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('edit')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'render topic partial' do
      expect(response).to render_template('posts/_form')
    end
    it 'returns a content in page' do
      expect(response.body).to match('post')
    end
  end
  describe 'POST #create' do
    context 'positive cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        post :create, params: { post: { name: 'post', description: 'kk', avatar: file }, topic_id: topic.id }
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
      end
      it 'returns a redirect status' do
        expect(response.status).to eq(302)
      end
      it 'returns the post count ' do
        expect(Post.count).to eq(1)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to("/topics/#{assigns(:topic).id}")
      end
      it 'Notifies a flash save' do
        expect(flash[:notice]).to eq('Posts was successfully created.')
      end
      it 'returns avatar present and validates the byte size' do

        user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
        user.confirm
        topic = Topic.create(title: 'anything', user_id: user.id)
        sign_in(user)
        p '1'
        postq = topic.posts.create(name: 'post', description: 'kk', user_id: user.id)
        p '2'
        postq.avatar.attach(io: File.open('C:\Users\gopal\image8.jfif'), filename: 'image8.jfif', content_type: 'image/jpeg')
        expect(postq.avatar.attached?).to be_present
        expect(postq.avatar.byte_size < 2000.kilobytes).to be_truthy
      end
    end

  end

  describe 'Update' do
    context 'PATCH #update' do
      context 'positive  cases' do
        before(:each) do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          user.confirm
          sign_in(user)
          file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
          topic = Topic.create(title: 'Anything', user_id: user.id)
          post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
          patch :update, params: { id: post.id, topic_id: topic.id, post: { name: 'Post', description: 'kkk' } }
        end
        it 'returns a content type' do
          expect(response.content_type).to eq 'text/html'
        end
        it 'returns a redirect status' do
          expect(response.status).to eq(302)
        end
        it 'Notifies a flash save' do
          expect(flash[:notice]).to eq('Posts was successfully updated')
        end
        it 'returns a redirect path' do
          expect(response).to redirect_to("/topics/#{assigns(:topic).id}/posts")
        end
        it 'returns a redirect status' do
          expect(response.status).to eq(302)

        end

      end
    end
    context 'negative cases' do
      context 'Not rendered views' do
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          user.confirm
          sign_in(user)
          topic = Topic.create(title: 'anything', user_id: user.id)
          file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
          post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
          patch :update, params: { id: post.id, tag_ids: 1, topic_id: topic.id, post: { name: '', description: '' } }
        end
        it 'returns a error message' do
          expect(assigns(:post).errors.messages).to eq(name: ["can't be blank"])
        end
        it 'returns a success status' do
          expect(response.status).to eq(200)
        end
      end
      context 'render views' do
        render_views
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          user.confirm
          sign_in(user)
          topic = Topic.create(title: 'anything', user_id: user.id)
          file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
          post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
          patch :update, params: { id: post.id, tag_ids: 1, topic_id: topic.id, post: { name: '', description: '' } }
        end
        it 'returns a error message' do
          expect(response.body).to match('1 error prohibited this posts from being saved:')
        end
        it 'returns a error message' do
          expect(response.body).to match ' <li>Name can&#39;t be blank</li>'
        end
        it 'render template edit' do
          expect(response).to render_template('edit')
        end
      end
    end
    context 'PUT #update' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
        put :update, params: { id: post.id, tag_ids: 1, topic_id: topic.id, post: { name: 'Posts', description: 'kkk' } }
      end
      it 'returns a redirect status' do
        expect(response.status).to eq (302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to("/topics/#{assigns(:topic).id}/posts")
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'destroys the requested posts' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      expect do
        delete :destroy, params: { id: post.id, topic_id: topic.id }
      end.to change { Post.count }.by(-1)
    end
    it 'notifies the flash message' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'anything', user_id: user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)

      delete :destroy, params: { id: post.id, topic_id: topic.id }
      expect(flash[:notice]).to eq('Posts was successfully destroyed.')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end

    it 'returns a redirect path' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      delete :destroy, params: { id: post.id, topic_id: topic.id }
      expect(response).to redirect_to(topic_posts_path)
    end

  end
  describe 'post comment destroy' do

    it 'destroys the comments posts' do
      user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      comment = post.comments.create!(comment: 'kk', user_id: user.id)
      expect do
        delete :destroy, params: { id: comment.id, topic_id: topic.id, post_id: post.id }
      end.to change { post.comments.count }.by(-1)
    end
  end
  describe 'POST #create' do
    render_views
    context 'positive cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        post :create, xhr: true, params: { post: { name: 'post', description: 'kk', avatar: file }, topic_id: topic.id }
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/javascript'
      end

      it 'returns the post count ' do
        expect(Post.count).to eq(1)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'alert test' do
        expect(response.body).to match('Post Created')
      end
    end
    context 'negative cases' do
      render_views
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'anything', user_id: user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
        patch :update, params: { id: post.id, tag_ids: 1, topic_id: topic.id, post: { name: '', description: '' } }
      end
      it 'returns a error message' do
        expect(response.body).to match('Name can&#39;t be blank')
      end
      it 'returns a success status' do
        expect(response.status).to eq(200)
      end
      end
  end
  describe 'Can Can User authorization' do
    context 'PATCH #update' do
      before do
        user = User.create(email: 'kishore@mallow-tech11.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything',user_id:user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
        sign_out(user)
        user1 = User.create(email: 'kishore@mallow-tech12.com', password: '9047446861')
        user1.confirm
        sign_in(user1)
        patch :update, params: { id: post.id, topic_id: topic.id, post: { name: 'Post', description: 'kkk' },user_id:user1.id }
      end
      it 'Notifies with a flash' do
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to(root_path)
      end
    end
    context 'DELETE #destroy' do
      before do
        user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        user1 = User.create(email: 'kishore@mallow-tech2.com', password: '9047446861')
        user1.confirm
        sign_in(user1)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
        delete :destroy, params: { id: post.id, topic_id: topic.id,user_id:user1.id }
      end
      it 'Notifies with a flash' do
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
  describe 'POST #read_status' do
    context 'positive cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        postq = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
        post :read_status, xhr: true, params: {id:postq.id}
      end

      it 'returns a status code' do
        expect(response.status).to eq(204)
      end
    end
    end
end
