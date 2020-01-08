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
describe "GET #new" do
  it "returns a success response" do
    get :new
    expect(response).to have_http_status(:success)
  end
end
  describe "POST #create" do
    context "with valid params" do
      it "creates a new Topic" do
        expect {
          post :create, params: {id: article.to_param}
        }.to change(Article, :count).by(1)
      end
    end
  end
end