require 'rails_helper'
RSpec.describe CommentsController, type: :controller do
  describe 'GET #show' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name: 'post', description: 'kk',user_id:user.id)
      comment = post.comments.create(user: 'comment', comment: 'kk')
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
      sign_in(user)
      topic = Topic.create(title: 'anything')
      post = topic.posts.create!(name:'post', description:'kk',user_id: user.id)
      comment = post.comments.create(user: 'comment', comment: 'kk')
      get :show, params: { post_id: post.id, topic_id: topic.id, id: comment.id }
      expect(assigns(:comment)).to eq(comment)
    end
    it 'returns a content in page' do
      expect(response.body).to match('comment')
    end
  end

  describe 'GET #edit' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name: 'post', description: 'kk',user_id: user.id)
      comment = post.comments.create(user: 'comment', comment: 'kk')
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
      expect(response.body).to match('post')
    end
  end
  describe 'POST #create' do
    context 'positive cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        sign_in(user)
        topic = Topic.create(title: 'Anything')
        postq = topic.posts.create(name: 'post', description: 'kk',user_id: user.id)
        post :create, params: { comment: { user: 'post', comment: 'kk' }, topic_id: topic.id,post_id:postq.id }
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
          sign_in(user)
          topic = Topic.create(title: 'Anything')
          postq = topic.posts.create(name: 'post', description: 'kk',user_id: user.id)
          post :create, params: { comment: { user: '', comment: '' }, topic_id: topic.id,post_id:postq.id }
        end
        it 'returns a error message' do
          expect(assigns(:comment).errors.messages).to eq(user: ["can't be blank"])
        end
        it 'returns a success status' do
          expect(response.status).to eq(200)
        end
      end
      context 'rendered views' do
        render_views
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          sign_in(user)
          topic = Topic.create(title: 'Anything')
          postq = topic.posts.create(name: 'post', description: 'kk',user_id: user.id)
          post :create, params: { comment: { user: '', comment: '' }, topic_id: topic.id,post_id:postq.id }
        end
        it 'returns a error message' do
          expect(response.body).to match('1 error prohibited this comment from being saved:')
        end
        it 'returns a error message' do
          expect(response.body).to match  ' <li>User can&#39;t be blank</li>'
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
          sign_in(user)
          topic = Topic.create(title: 'Anything')
          post = topic.posts.create(name: 'post', description: 'kk',user_id: user.id)
          comment = post.comments.create(user: 'comment', comment: 'kk')
          patch :update, params: { id:comment.id,post_id:post.id, topic_id: topic.id,comment:{ user: 'post', comment: 'kkk' } }
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
          expect(response).to redirect_to("/topics/#{assigns(:topic).id}/posts/#{assigns(:posts).id}")
        end

      end
    end
    context 'negative cases' do
      context 'Not rendered views' do
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          sign_in(user)
          topic = Topic.create(title: 'anything')
          post = topic.posts.create(name: 'post', description: 'kk',user_id: user.id)
          comment = post.comments.create(user: 'comment', comment: 'kk')
          patch :update, params: { id:comment.id,post_id:post.id, topic_id: topic.id,comment:{ user: '', comment: 'kkk' } }
        end
        it 'returns a error message' do
          expect(assigns(:comment).errors.messages).to eq(user: ["can't be blank"])
        end
        it 'returns a success status' do
          expect(response.status).to eq(200)
        end
      end
      context 'render views' do
        render_views
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          sign_in(user)
          topic = Topic.create(title: 'anything')
          post = topic.posts.create(name: 'post', description: 'kk',user_id: user.id)
          comment = post.comments.create(user: 'comment', comment: 'kk')
          patch :update, params: { id:comment.id,post_id:post.id, topic_id: topic.id,comment:{ user: '', comment: 'kkk' } }
        end
        it 'returns a error message' do
          expect(response.body).to match('1 error prohibited this comment from being saved:')
        end
        it 'returns a error message' do
          expect(response.body).to match  ' <li>User can&#39;t be blank</li>'
        end
        it 'render template edit' do
          expect(response).to render_template('edit')
        end
      end
    end
    context 'PUT #update' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        sign_in(user)
        topic = Topic.create(title: 'Anything')
        post = topic.posts.create(name: 'post', description: 'kk',user_id: user.id)
        comment = post.comments.create(user: 'comment', comment: 'kk')
        put :update, params: { id:comment.id,post_id:post.id, topic_id: topic.id,comment:{ user: 'post', comment: 'kkk' } }
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
      sign_in(user)
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name:'post', description:'kk',user_id: user.id)
      comment = post.comments.create(user: 'comment', comment: 'kk')
      expect {
        delete :destroy, params: { id: comment.id, topic_id: topic.id,post_id:post.id }
      }.to change{Comment.count}.by(-1)
    end
    it 'notifies the flash message' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      topic = Topic.create(title: 'anything')
      post = topic.posts.create(name:'post', description:'kk',user_id: user.id)
      comment = post.comments.create(user: 'comment', comment: 'kk')
      delete :destroy, params: { id: comment.id, topic_id: topic.id,post_id: post.id }
      expect(flash[:notice]).to eq('Comment was successfully destroyed')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a redirect path' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name:'post', description:'kk',user_id: user.id)
      comment = post.comments.create(user: 'comment', comment: 'kk')
      delete :destroy, params: { id: comment.id, topic_id: topic.id,post_id:post.id }
      expect(response).to redirect_to(topic_post_path(id: post.id))
    end
    it 'returns a ActiveRecord::RecordNotFound and redirect' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name:'post', description:'kk',user_id: user.id)
      delete :destroy, params: { id: -1, topic_id: topic.id,post_id: post.id }
      expect(flash[:notice]).to eq('Record not found.')
      expect(response).to redirect_to(topic_post_path(id:post.id))
    end
  end
end

