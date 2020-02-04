require 'rails_helper'
RSpec.describe ArticlesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  it 'return an success response' do
    article=Article.create(title: 'Anything', text: 'Anything')
    get :show, params: {id: article.to_param}
    expect(response).to have_http_status(:success)
  end

  it 'Notifies a successful save' do
    article=Article.create(title: 'Anything', text: 'Anything')
    post :show, params: {id: article.to_param}
    expect(response.content_type).to eq 'text/html'
  end
  it 'Notifies a successful save' do
    article=Article.create(title: 'Anything', text: 'Anything')
    patch :update, params: {id: article.to_param}
    expect(response.content_type).to eq 'text/html'
  end
end

