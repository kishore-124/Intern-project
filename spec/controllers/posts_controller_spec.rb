require 'rails_helper'
RSpec.describe PostsController, type: :controller do
  describe 'GET #index' do
    before do
      get :index
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a rendered template type' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('index')
    end
    it 'assigns @posts' do
      topic = Topic.create(title: 'anything')
      post = topic.posts.create(name:'post', description:'kk')
      expect(assigns(:posts)).to eq([post])
    end
    it 'checks the pagination limit value' do
      expect(assigns(:posts).limit_value).to eq(10)
    end
    it 'Checks the Page offset correctly' do
      1.upto(34) do
        topic=Topic.create(title: 'Anything')
        post = topic.posts.create(name:'post', description:'kk')
      end
      get :index, params: {page: 4}
      expect(assigns[:posts].map(&:id).count).to eq(4)
    end
    end
  describe 'GET #show' do
    render_views
    before do
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name: 'post' , description: 'kk')
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
      topic = Topic.create(title: 'anything')
      post = topic.posts.create(name:'post', description:'kk')
      get :show, params: { id: post.id, topic_id: topic.id }
      expect(assigns(:posts)).to eq(post)
    end
    it 'returns a content in page' do
      expect(response.body).to match('post')
    end
  end

  describe 'GET #edit' do
    render_views
    before do
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name: 'post' , description: 'kk')
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
        topic = Topic.create(title: 'Anything')
        post :create, params: { post: { name: 'post', description: 'kk' }, topic_id: topic.id }
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
      end
      it 'returns a redirect status' do
        expect(response.status).to eq(302)
      end
      it 'returns a redirect path' do
        topic = Topic.create(title: 'Anything')
        post :create, params: { post: { name: 'post', description: 'kk' }, topic_id: topic.id }
        expect(response).to redirect_to(topic_path(id: topic.id ))
      end
      it 'Notifies a flash save' do
        expect(flash[:notice]).to eq('Posts was successfully created')
      end
    end
    context 'negative cases' do
      context 'not rendered views' do
        before do
          topic = Topic.create(title: 'Anything')
          post :create, params: { post: { name: '', description: '' }, topic_id: topic.id }
        end
        it 'returns a error message' do
          expect(assigns(:posts).errors.messages).to eq(name: ["can't be blank"])
        end
        it 'returns a success status' do
          expect(response.status).to eq(200)
        end
      end
      context 'rendered views' do
        render_views
        before do
          topic = Topic.create(title: 'Anything')
          post :create, params: { post: { name: '', description: '' }, topic_id: topic.id }
        end
        it 'returns a error message' do
          expect(response.body).to match('1 error prohibited this posts from being saved:')
        end
        it 'returns a error message' do
          expect(response.body).to match  ' <li>Name can&#39;t be blank</li>'
        end
        it 'render template show' do
          expect(response).to render_template('topics/show')
        end
      end
    end
  end

  describe 'Update' do
    context 'PATCH #update' do
      context 'positive  cases' do
        before do
          topic = Topic.create(title: 'Anything')
          post = topic.posts.create(name: 'post' , description: 'kk')
          patch :update, params: { id:post.id,tag_ids: 1, topic_id: topic.id ,post:{name: 'Post' , description: 'kkk'}}
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
          topic = Topic.create(title: 'Anything')
          post = topic.posts.create(name: 'post' , description: 'kk')
          patch :update, params: { id:post.id,tag_ids: 1, topic_id: topic.id ,post:{name: 'Post' , description: 'kkk'}}
          expect(response).to redirect_to(topic_posts_path(topic_id: topic.id))
        end
        it 'returns a redirect status' do
          expect(response.status).to eq(302)
        end
      end
    end
    context 'negative cases' do
      context 'Not rendered views' do
      before do
        topic = Topic.create(title: 'anything')
        post = topic.posts.create(name: 'post' , description: 'kk')
        patch :update, params: { id:post.id,tag_ids: 1, topic_id: topic.id ,post:{name: '' , description: ''}}
      end
      it 'returns a error message' do
        expect(assigns(:posts).errors.messages).to eq(name: ["can't be blank"])
      end
      it 'returns a success status' do
        expect(response.status).to eq(200)
      end
      end
      context 'render views' do
        render_views
        before do
          topic = Topic.create(title: 'anything')
          post = topic.posts.create(name: 'post' , description: 'kk')
          patch :update, params: { id:post.id,tag_ids: 1, topic_id: topic.id ,post:{name: '' , description: ''}}
        end
        it 'returns a error message' do
          expect(response.body).to match('1 error prohibited this posts from being saved:')
        end
        it 'returns a error message' do
          expect(response.body).to match  ' <li>Name can&#39;t be blank</li>'
        end
        it 'render template edit' do
          expect(response).to render_template('edit')
        end
      end
    end
    context 'PUT #update' do
      before do
        topic = Topic.create(title: 'Anything')
        post = topic.posts.create(name: 'post' , description: 'kk')
        put :update, params: { id:post.id,tag_ids: 1, topic_id: topic.id ,post:{name: 'Posts' , description: 'kkk'}}
      end
      it 'returns a redirect status' do
        expect(response.status).to eq (302)
      end
      it 'returns a redirect path' do
        topic = Topic.create(title: 'Anything')
        post = topic.posts.create(name: 'post' , description: 'kk')
        put :update, params: { id:post.id,tag_ids: 1, topic_id: topic.id ,post:{name: 'Posts' , description: 'kkk'}}
        expect(response).to redirect_to(topic_posts_path(topic_id: topic.id))
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'destroys the requested posts' do
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name:'post', description:'kk')
      expect {
        delete :destroy, params: {id: post.id, topic_id: topic.id}
      }.to change{Post.count}.by(-1)
    end
    it 'notifies the flash message' do
      topic = Topic.create(title: 'anything')
      post = topic.posts.create(name:'post', description:'kk')
      delete :destroy, params: { id: post.id, topic_id: topic.id }
      expect(flash[:notice]).to eq('Posts was successfully destroyed.')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a redirect path' do
      topic = Topic.create(title: 'Anything')
      post = topic.posts.create(name:'post', description:'kk')
      delete :destroy, params: { id: post.id, topic_id: topic.id }
      expect(response).to redirect_to(topic_posts_path)
    end
    it 'returns a ActiveRecord::RecordNotFound and redirect' do
      topic = Topic.create(title: 'Anything')
      delete :destroy, params: { id: -1, topic_id: topic.id }
      expect(flash[:notice]).to eq('Record not found.')
      expect(response).to redirect_to(topic_posts_path)
    end
  end
end

