require 'rails_helper'
RSpec.describe TagsController, type: :controller do
  describe 'GET #index' do
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      get :index
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a rendered template format' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('index')
    end
    it 'assigns @tag' do
      tag = Tag.create(name: 'anything')
      expect(assigns(:tags)).to eq([tag])
    end
    it 'checks the pagination limit value' do
      expect(assigns(:tags).limit_value).to eq(10)
    end
    it 'Checks the Page offset correctly' do
      1.upto(12) do
        tag=Tag.create(name: "Anything")
      end
      get :index, params: {page: 2}
      expect(assigns[:tags].map(&:id).count).to eq(2)
    end
  end
  describe 'GET #show' do
      render_views
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        sign_in(user)
        tag = Tag.create(name: 'Anything')
        get :show, params: {id: tag.to_param}
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
        expect(response).to render_template('show')
      end
      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end
      it 'assigns @tag' do
        tag = Tag.create(name: 'anything')
        get :show,  params: {id: tag.to_param}
        expect(assigns(:tag)).to eq(tag)
      end
      it 'returns a content in page' do
        expect(response.body).to match('Anything')
      end
  end
  describe 'GET #new' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
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
      expect(response).to render_template('tags/_form')
    end
  end

  describe 'GET #edit' do
    render_views
    before do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      tag = Tag.create(name: 'Anything')
      get :edit, params: {id: tag.to_param}
    end
    it 'returns a content type of the page' do
      expect(response.content_type).to eq 'text/html'
      expect(response).to render_template('edit')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'render topic partial' do
      expect(response).to render_template('tags/_form')
    end
  end
  describe 'POST #create' do
    context 'positive cases' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        sign_in(user)
        post :create, params: {tag: {name: 'Anything'}}
      end
      it 'returns a content type' do
        expect(response.content_type).to eq 'text/html'
      end
      it 'returns a rendered status' do
        expect(response.status).to eq(302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to("/tags/#{assigns(:tag).id}")
      end
      it 'returns a change the tag count' do
        expect {
          post :create, params: {tag: {name: 'Anything'}}
        }.to change(Tag, :count).by(1)
      end
      it 'Notifies a flash save' do
        # expect(flash[:notice]).to eq('Topic was successfully created.')
        should set_flash[:notice].to('Tag was successfully created.')
      end
    end
    context 'negative cases' do
      render_views
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        sign_in(user)
        post :create, params: {tag: {name: ''}}
      end
      it 'returns a error message' do
        expect(assigns(:tag).errors.messages).to eq(:name => ["can't be blank"])
      end
      it 'returns a error message' do
        expect(response.body).to match('1 error prohibited this tag from being saved:')
      end
      it 'returns a error message' do
        expect(response.body).to match  ' <li>Name can&#39;t be blank</li>'
      end
      it 'returns a success status' do
        expect(response.status).to eq (200)
      end
      it 'returns a rendered template' do
        expect(response).to render_template('new')
      end
    end
  end
  describe 'Update' do
    context 'PATCH #update' do
      context 'positive  cases' do
        before do
          user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
          sign_in(user)
          tag = Tag.create(name: 'Anythings')
          patch :update, params: {id: tag.to_param, tag: {name: 'value'}}
        end
        it 'returns a content type' do
          expect(response.content_type).to eq 'text/html'
        end
        it 'returns a rendered status' do
          expect(response.status).to eq(302)
        end
        it 'Notifies a flash save' do
          expect(flash[:notice]).to eq('Tag was successfully updated.')
        end
        it 'returns a redirect path' do
          expect(response).to redirect_to("/tags/#{assigns(:tag).id}")
        end
      end
    end
    context 'negative cases' do
      render_views
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        sign_in(user)
        tag = Tag.create(name: 'Anything')
        patch :update, params: {id: tag.to_param, tag: {name: ''}}
      end
      it 'returns a error message' do
        expect(assigns(:tag).errors.messages).to eq(:name => ["can't be blank"])
      end
      it 'returns a error message' do
        expect(response.body).to match('1 error prohibited this tag from being saved:')
      end
      it 'returns a error message' do
        expect(response.body).to match  ' <li>Name can&#39;t be blank</li>'
      end
      it 'returns a success status' do
        expect(response.status).to eq (200)
      end
      it 'returns a rendered template' do
        expect(response).to render_template('edit')
      end
    end
    context 'PUT #update' do
      before do
        user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
        sign_in(user)
        tag = Tag.create(name: 'Anything')
        put :update, params: {id: tag.to_param, tag: {name: 'Anything'}}
      end
      it 'returns a rendered status' do
        expect(response.status).to eq (302)
      end
      it 'returns a redirect path' do
        expect(response).to redirect_to("/tags/#{assigns(:tag).id}")
      end
      it 'Notifies a flash save' do
        expect(flash[:notice]).to eq('Tag was successfully updated.')
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'destroys the requested topic' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      tag = Tag.create(name: 'Anything')
      expect {
        delete :destroy, params: {id: tag.to_param}
      }.to change { Tag.count }.by(-1)
    end
    it 'notifies the flash message' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      tag = Tag.create(name: 'Anything')
      delete :destroy, params: {id: tag.to_param}
      expect(flash[:notice]).to eq('Tag was successfully destroyed.')
    end
    it 'returns a success response' do
      expect(response).to have_http_status(:success)
    end
    it 'returns a redirect path' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      tag = Tag.create(name: 'Anything')
      delete :destroy, params: {id: tag.to_param}
      expect(response).to redirect_to(tags_path)
    end
    it 'returns a ActiveRecord::RecordNotFound and redirect path' do
      user = User.create(email: 'kishore@mallow-tech.com', password: '9047446861')
      sign_in(user)
      delete :destroy , params: {id: -1}
      expect(flash[:notice]).to eq('Record not found.')
      expect(response).to redirect_to(tags_path)
    end
  end
end
