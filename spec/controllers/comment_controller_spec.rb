# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CommentsController, type: :controller do
  describe 'GET #show' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      topic = Topic.create(title: 'Anything',user_id:user.id)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      comment = post.comments.create!( comment: 'kk', user_id: user.id)
      get :show, params: { post_id: post.id, topic_id: topic.id, id: comment.id }
    end
    it 'returns a content type' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('show')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns the value of the instance' do
      user = User.create!(email: 'kishore@mallow-tech1.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'anything',user_id:user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create!(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      comment = post.comments.create( comment: 'kk', user_id: user.id)
      get :show, params: { post_id: post.id, topic_id: topic.id, id: comment.id }
      expect(assigns(:comment)).to eq(comment)
    end
    it 'returns a content in page' do
      expect(response.body).to match('kk')
    end
  end

  describe 'GET #edit' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything',user_id:user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      comment = post.comments.create( comment: 'kk', user_id: user.id)
      get :show, params: { post_id: post.id, topic_id: topic.id, id: comment.id }
    end
    it 'returns a content type of the page' do
      expect(response.content_type).to eq 'text/html'
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'render topic partial' do
      expect(response).to render_template('comments/show')
    end
    it 'returns a content in page' do
      expect(response.body).to match('kk')
    end
  end
  describe 'POST #create' do
    context 'positive cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything',user_id:user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        postq = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
        post :create, params: { comment: { comment: 'kk', user_id: user.id }, topic_id: topic.id, post_id: postq.id }
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
      end
      it 'returns a redirect status' do
        expect(response.status).to eq(302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to("/topics/#{assigns(:topic).id}/posts/#{assigns(:posts).id}")
      end

      it 'Notifies a flash save' do
        expect(flash[:notice]).to eq('comment was successfully created')
      end
    end
    context 'negative cases' do
      context 'not rendered views' do
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          user.confirm
          sign_in(user)
          topic = Topic.create(title: 'Anything',user_id:user.id)
          file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
          postq = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
          post :create, params: { comment: { comment: '', user_id: user.id }, topic_id: topic.id, post_id: postq.id }
        end
        it 'returns a error message' do
          expect(assigns(:comment).errors.messages).to eq(comment: ["can't be blank"])
        end
        it 'returns a success status' do
          expect(response.status).to eq(200)
        end
      end
      context 'rendered views' do
        render_views
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          user.confirm
          sign_in(user)
          topic = Topic.create(title: 'Anything',user_id:user.id)
          file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
          postq = topic.posts.create!(name: 'post', description: 'kk', user_id: user.id, avatar: file)
          post :create, params: { comment: {  comment: '', user_id: user.id }, topic_id: topic.id, post_id: postq.id }
        end
        it 'returns a error message' do
          expect(response.body).to match('1 error prohibited this comment from being saved:')
        end
        it 'returns a error message' do
          expect(response.body).to match ' <li>Comment can&#39;t be blank</li>'
        end
        it 'render template show' do
          expect(response).to render_template('posts/show')
        end
      end
    end
  end

  describe 'Update' do
    context 'PATCH #update' do
      context 'positive  cases' do
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          user.confirm
          sign_in(user)
          topic = Topic.create(title: 'Anything',user_id:user.id)
          file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
          post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
          comment = post.comments.create(comment: 'kk', user_id: user.id)
          patch :update, params: { id: comment.id, post_id: post.id, topic_id: topic.id, comment: { comment: 'kkk', user_id: user.id} }
        end
        it 'returns a content type' do
          expect(response.content_type).to eq 'text/html'
        end
        it 'returns a redirect status' do
          expect(response.status).to eq(302)
        end
        it 'Notifies a flash save' do
          expect(flash[:notice]).to eq('comment was successfully updated')
        end
        it 'returns a redirect path' do
          expect(response).to redirect_to("/topics/#{assigns(:topic).id}/posts/#{assigns(:post).id}")
        end

      end
    end
    context 'negative cases' do
      context 'Not rendered views' do
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          user.confirm
          sign_in(user)
          topic = Topic.create(title: 'anything',user_id:user.id)
          file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
          post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
          comment = post.comments.create(comment: 'kk', user_id: user.id)
          patch :update, params: { id: comment.id, post_id: post.id, topic_id: topic.id, comment: { comment: '', user_id: user.id} }
        end
        it 'returns a error message' do
          expect(assigns(:comment).errors.messages).to eq(comment: ["can't be blank"])
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
          topic = Topic.create(title: 'anything',user_id:user.id)
          file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
          post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
          comment = post.comments.create(comment: 'kk', user_id: user.id)
          patch :update, params: { id: comment.id, post_id: post.id, topic_id: topic.id, comment: {  comment: '', user_id: user.id } }
        end
        it 'returns a error message' do
          expect(response.body).to match('1 error prohibited this comment from being saved:')
        end
        it 'returns a error message' do
          expect(response.body).to match ' <li>Comment can&#39;t be blank</li>'
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
        topic = Topic.create(title: 'Anything',user_id:user.id)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
        comment = post.comments.create(comment: 'kk', user_id: user.id)
        put :update, params: { id: comment.id, post_id: post.id, topic_id: topic.id, comment: { comment: 'kkk', user_id: user.id } }
      end
      it 'returns a redirect status' do
        expect(response.status).to eq (302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to("/topics/#{assigns(:topic).id}/posts/#{assigns(:posts).id}")
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'destroys the requested posts' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything',user_id:user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      comment = post.comments.create(comment: 'kk', user_id: user.id)
      expect {
        delete :destroy, params: { id: comment.id, topic_id: topic.id, post_id: post.id }
      }.to change{Comment.count}.by(-1)
    end

    it 'notifies the flash message' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'anything',user_id:user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      comment = post.comments.create(comment: 'kk', user_id: user.id)
      delete :destroy, params: { id: comment.id, topic_id: topic.id, post_id: post.id }
      expect(flash[:notice]).to eq('Comment was successfully destroyed')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a redirect path' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything',user_id:user.id)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      post = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      comment = post.comments.create(comment: 'kk', user_id: user.id)
      delete :destroy, params: { id: comment.id, topic_id: topic.id, post_id: post.id }
      expect(response).to redirect_to(topic_post_path(id: post.id))
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
        comment = post.comments.create(comment: 'kk', user_id: user.id)
        sign_out(user)
        user1 = User.create(email: 'kishore@mallow-tech12.com', password: '9047446861')
        user1.confirm
        sign_in(user1)
        patch :update, params: { id: comment.id, post_id: post.id, topic_id: topic.id, comment: { comment: 'kkk',user_id:user.id},user_id:user1.id }
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
          comment = post.comments.create(comment: 'kk', user_id: user.id)
          delete :destroy, params: { id: comment.id, topic_id: topic.id, post_id: post.id ,user_id:user1.id}
      end
      it 'Notifies with a flash' do
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to(root_path)
      end
    end
    end

  describe 'POST #user_comment_rating' do
    context "positive cases" do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
      topic = Topic.create(title: 'Anything',user_id:user.id)
      postq = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
      comment = postq.comments.create( comment: 'kkkk', user_id: user.id)
      post :user_comment_rating, params: { user_comment_rating: { star: 1 }, topic_id: postq.topic_id,post_id: postq.id ,comment_id:comment.id}
    end
    it 'returns a content type' do
      expect(response.content_type).to eq 'text/html'
    end
    it 'returns a redirect status' do
      expect(response.status).to eq(302)
    end
    it 'Notifies a flash save' do
      expect(flash[:notice]).to eq('Rating added successfully')
    end
    end
    context 'Negative cases' do
      render_views
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        file = fixture_file_upload(Rails.root.join('C:\Users\gopal\image8.jfif'), 'image/jpeg', :binary)
        topic = Topic.create(title: 'Anything',user_id:user.id)
        postq = topic.posts.create(name: 'post', description: 'kk', user_id: user.id, avatar: file)
        comment = postq.comments.create( comment: 'kkkk', user_id: user.id)
       comment.user_comment_ratings.create(star: 1,user_id:user.id)
        post :user_comment_rating, params: { user_comment_rating: { star: 2 }, topic_id: postq.topic_id,post_id: postq.id ,comment_id:comment.id}
      end
      it 'returns a content type' do
        expect(flash[:alert]).to eq('user already given rating')
      end
    end
  end

end

