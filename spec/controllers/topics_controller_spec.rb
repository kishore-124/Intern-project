require 'rails_helper'
RSpec.describe TopicsController, type: :controller do
  describe 'GET #index' do
    context "Not render views" do
      before do
        get :index
      end
      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end
      it 'returns a rendered template format' do
        expect(response.content_type).to eq 'text/html'
        expect(response).to render_template('index')
      end
      it 'assigns @topics' do
        topic = Topic.create(title: 'anything')
        expect(assigns(:topics)).to eq([topic])
      end
    end
    context "Pagination test cases" do
      before do
        get :index
      end
      it 'checks the limits of a page' do
        expect(assigns[:topics].limit_value).to eq(10)
      end
      it 'Checks the Page offset correctly' do
        1.upto(24) do
          topic=Topic.create(title: "Anything")
        end
        get :index, params: {page: 3}
        expect(assigns[:topics].map(&:id).count).to eq(4)
      end
    end
  end
  describe 'GET #show' do
    context 'Topic GET#show'do
    render_views
    before do
      topic = Topic.create(title: 'Anything')
      get :show, params: {id: topic.to_param}
    end
    it 'returns a content type' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('show')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns @topics' do
      topic = Topic.create(title: 'Anything')
      get :show, params: {id: topic.to_param}
      expect(assigns(:topic)).to eq(topic)
    end
    it 'returns a content in page' do
      expect(response.body).to match('Anything')
    end
    end
    context 'Post #new' do
      render_views
      before do
        topic = Topic.create(title: 'Anything')
        get :show, params: {id: topic.to_param}
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
      topic = Topic.create(title: 'Anything')
      get :edit, params: {id: topic.to_param}
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
        post :create, params: {topic: {title: 'Anything'}}
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
      end
      it 'returns a rendered status' do
        expect(response.status).to eq(302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to(topic_path(id: 1))
      end
      it 'returns a change the topic count' do
        expect {
          post :create, params: {topic: {title: 'Anything'}}
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
        post :create, params: {topic: {title: ''}}
      end
      it 'returns a error message' do
        expect(assigns(:topic).errors.messages).to eq(:title => ["can't be blank"])
      end
      it 'returns a error message' do
        expect(response.body).to match('1 error prohibited this topic from being saved:')
      end
      it 'returns a error message' do
        expect(response.body).to match  ' <li>Title can&#39;t be blank</li>'
      end
    end
  end
  describe 'Update' do
    context 'PATCH #update' do
      context 'positive  cases' do
        before do
          topic = Topic.create(title: 'Anythings')
          patch :update, params: {id: topic.to_param, topic: {title: 'value'}}
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
          expect(response).to redirect_to(topic_path(id: 1))
        end
      end
    end
    context 'negative cases' do
      render_views
      before do
        topic = Topic.create(title: 'Anything')
        patch :update, params: {id: topic.to_param, topic: {title: ''}}
      end
      it 'returns a error message' do
        expect(assigns(:topic).errors.messages).to eq(:title => ["can't be blank"])
      end
      it 'returns a error message' do
        expect(response.body).to match('1 error prohibited this topic from being saved:')
      end
      it 'returns a error message' do
        expect(response.body).to match  ' <li>Title can&#39;t be blank</li>'
      end
    end
    context 'PUT #update' do
      before do
        topic = Topic.create(title: 'Anything')
        put :update, params: {id: topic.to_param, topic: {title: 'Anything'}}
      end
      it 'returns a rendered status' do
        expect(response.status).to eq (302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to(topic_path(id: 1))
      end
      it 'Notifies a flash save' do
        expect(flash[:notice]).to eq('Topic was successfully updated.')
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'destroys the requested topic' do
      topic = Topic.create(title: 'Anything')
      expect {
        delete :destroy, params: {id: topic.to_param}
      }.to change { Topic.count }.by(-1)
    end
    it 'notifies the flash message' do
      topic = Topic.create(title: 'Anything')
      delete :destroy, params: {id: topic.to_param}
      expect(flash[:notice]).to eq('Topic was successfully destroyed.')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a redirect path' do
      topic = Topic.create(title: 'Anything')
      delete :destroy, params: {id: topic.to_param}
      expect(response).to redirect_to(topics_path)
    end
    it 'returns a ActiveRecord::RecordNotFound and redirect path' do
      delete :destroy , params: {id: -1}
      expect(flash[:notice]).to eq('Record not found.')
      expect(response).to redirect_to(topics_path)
    end
  end
end
