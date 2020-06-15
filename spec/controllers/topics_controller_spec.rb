require 'rails_helper'
RSpec.describe TopicsController, type: :controller do
  describe 'GET #index' do
    context 'Not render views' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        get :index, params: { user_id: user.id }
      end
      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns a rendered template format' do
        expect(response.content_type).to eq 'text/html'
        expect(response).to render_template('index')
      end
      it 'assigns @topics' do
        user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create!(title: 'anything', user_id: user.id)
        expect(assigns(:topics)).to eq([topic])
      end
    end
    context 'Pagination test cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        get :index, params: { user_id: user.id }
      end
      it 'checks the limits of a page' do
        expect(assigns[:topics].limit_value).to eq(10)
      end
      it 'Checks the Page offset correctly' do
        user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
        user.confirm
        sign_in(user)
        1.upto(24) do
          topic=Topic.create(title: 'Anything', user_id: user.id)
        end
        get :index, params: { page: 3 }
        expect(assigns[:topics].map(&:id).count).to eq(4)
      end
    end
    context 'JSON test cases' do
      before(:each) do
        request.headers["accept"] = 'application/json'
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        get :index
      end
      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end
      it 'returns a rendered template format' do
        expect(response.content_type).to eq 'application/json'
      end
      end
  end
  describe 'GET #show' do
    context 'Topic GET#show'do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      get :show, params: { id: topic.to_param }
    end
    it 'returns a content type' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('show')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns @topics' do
      user = User.create(email: 'kishore@mallow-tech1.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create!(title: 'Anything', user_id: user.id)
      get :show, params: { id: topic.to_param }
      expect(assigns(:topic)).to eq(topic)
    end
    it 'returns a content in page' do
      expect(response.body).to match('Anything')
    end
    end
    context 'Post #new' do
      render_views
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        get :show, params: { id: topic.to_param }
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
        expect(response).to render_template('show')
      end
      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end
      it 'render topic partial' do
        expect(response).to render_template('posts/_form')
      end
    end

  end
  describe 'GET #new' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      get :new
    end
    it 'returns a content type' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('new')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'render topic partial' do
      expect(response).to render_template('topics/_form')
    end
  end

  describe 'GET #edit' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      get :edit, params: { id: topic.to_param }
    end
    it 'returns a content type of the page' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('edit')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'render topic partial' do
      expect(response).to render_template('topics/_form')
    end
  end
  describe 'POST #create' do
    context 'positive cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        post :create, params: { topic: { title: 'Anything', user_id: user.id } }
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
      end
      it 'returns a rendered status' do
        expect(response.status).to eq(302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to("/topics/#{assigns(:topic).id}")
      end
      it 'returns a change the topic count' do
        expect {
          post :create, params: { topic: { title: 'Anything' } }
        }.to change(Topic, :count).by(1)
      end
      it 'Notifies a flash save' do
        # expect(flash[:notice]).to eq('Topic was successfully created.')
        should set_flash[:notice].to('Topic was successfully created.')
      end
    end
    context 'negative cases' do
      render_views
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        post :create, params: { topic: { title: '', usere_id: user.id } }
      end
      it 'returns a error message' do
        expect(assigns(:topic).errors.messages).to eq(:title => ["can't be blank"])
      end
      it 'returns a error message' do
        expect(response.body).to match('1 error prohibited this topic from being saved')
      end

    end
    context 'Json positive Cases' do
      before(:each) do
        request.headers["accept"] = 'application/json'
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        post :create, params: { topic: { title: 'Anything', user_id: user.id } }
      end
      it 'returns content type' do
        expect(response.content_type).to eq 'application/json'
      end
      it 'returns a status' do
        expect(response).to have_http_status(:created)
      end
      it 'render template' do
        expect(response).to render_template(:show)
      end
    end
    context 'Json negative Cases' do
      before(:each) do
        request.headers["accept"] = 'application/json'
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        post :create, params: { topic: { title: '', user_id: user.id } }
      end
      it 'returns content type' do
        expect(response.content_type).to eq 'application/json'
      end
      it 'returns a status' do
        expect(response).to have_http_status(:unprocessable_entity)
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
          topic = Topic.create(title: 'Anythings', user_id: user.id)

          patch :update, params: { id: topic.to_param, topic: { title: 'value', user_id: user.id } }
        end
        it 'returns a content type' do
          expect(response.content_type).to eq 'text/html'
        end
        it 'returns a rendered status' do
          expect(response.status).to eq(302)
        end
        it 'Notifies a flash save' do
          expect(flash[:notice]).to eq('Topic was successfully updated.')
        end
        it 'returns a redirect path' do
          expect(response).to redirect_to("/topics/#{assigns(:topic).id}")
        end
      end
    end
    context 'negative cases' do
      render_views
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        patch :update, params: { id: topic.to_param, topic: { title: '', user_id: user.id } }
      end
      it 'returns a error message' do
        expect(assigns(:topic).errors.messages).to eq(:title => ["can't be blank"])
      end
      it 'returns a error message' do
        expect(response.body).to match('1 error prohibited this topic from being saved')
      end

    end
    context 'PUT #update' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        put :update, params: { id: topic.to_param, topic: { title: 'Anything', user_id: user.id } }
      end
      it 'returns a rendered status' do
        expect(response.status).to eq (302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to("/topics/#{assigns(:topic).id}")
      end
      it 'Notifies a flash save' do
        expect(flash[:notice]).to eq('Topic was successfully updated.')
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'destroys the requested topic' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      expect {
        delete :destroy, params: { id: topic.to_param }
      }.to change { Topic.count }.by(-1)
    end
    it 'notifies the flash message' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      delete :destroy, params: { id: topic.to_param }
      expect(flash[:notice]).to eq('Topic was successfully destroyed.')
    end
    it 'returns a json no content' do
      request.headers["accept"] = 'application/json'
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      delete :destroy, params: { id: topic.to_param }
      expect(response).to have_http_status(:no_content)
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a redirect path' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      topic = Topic.create(title: 'Anything', user_id: user.id)
      delete :destroy, params: { id: topic.to_param }
      expect(response).to redirect_to(topics_path)
    end
    it 'returns a ActiveRecord::RecordNotFound and redirect path' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      user.confirm
      sign_in(user)
      delete :destroy , params: { id: -1 }
      expect(response).to render_template('layouts/application')
    end
  end
  describe 'Can Can User authorization' do
    context 'PATCH #update' do
      before do
        user = User.create(email: 'kishore@mallow-tech11.com', password: '9047446861')
        user.confirm
        sign_in(user)
        topic = Topic.create(title: 'Anything', user_id: user.id)
        sign_out(user)
        user1 = User.create(email: 'kishore@mallow-tech12.com', password: '9047446861')
        user1.confirm
        sign_in(user1)
        patch :update, params: { id: topic.to_param, topic: { title: 'value', user_id: user.id }, user_id:user1.id }
      end
      it 'Notifies with a flash' do
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
      end

        it { should redirect_to(root_url) }

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
        delete :destroy, params: { id: topic.to_param, user_id:user1.id }
      end
      it 'Notifies with a flash' do
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
