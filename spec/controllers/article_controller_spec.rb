require 'rails_helper'
RSpec.describe ArticlesController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
  context "GET #show"
  it "return an success response" do
    article=Article.create(title: 'Anything', text: 'Anything')
    get :show, params: {id: article.to_param}
    expect(response).to have_http_status(:success)
  end
  describe "POST #create" do
    it "return a success status" do
      article=Article.create(title: 'Anything', text: 'Anything')
    post :create, params: {id: article.to_param}
    expect(response).to have_http_status(:"302")
    end
    end
  end