require 'rails_helper'
RSpec.describe TopicsController, type: :controller do
  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
  describe "GET #show" do
    it "returns a success response" do
      topic = Topic.create(title: 'Anything')
      get :show, params: {id: topic.to_param}
      expect(response).to be_successful
    end
  end
  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}
      expect(response.content_type).to eq "text/html"
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      topic = Topic.create(title: 'Anything')
      get :edit, params: {id: topic.to_param}
      expect(response.content_type).to eq "text/html"

    end
  end
  describe "POST #create" do
    context "with valid params" do
      it "Notifies a successful save" do
        topic=Topic.create(title: 'Anything')
        post :create, params: {id: topic.to_param}
        expect(response.content_type).to eq "text/html"
      end
    end
  end
  describe "PUT #update" do
    context "with valid params" do
      it "Notifies a successful save" do
        topic=Topic.create(title: 'Anything')
        patch :update, params: {id: topic.to_param}
        expect(response.content_type).to eq "text/html"
      end
    end
  end
  describe "DELETE #destroy" do
    it "destroys the requested topic" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("kishore:kishore")
      topic = Topic.create(title: 'Anything')
      expect {
        delete :destroy, params: {id: topic.to_param}
      }.to change{Topic.count}.by(-1)
    end

  end

#redirect test cases
 describe "POST #create" do
    it "returns a success response" do
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("kishore:kishore")
      expect {
        post :create,params:{ topic:{title: "Anything"} }
      }.to change(Topic,:count).by(1)
      expect(response).to redirect_to(topic_path(id: 1))
    end
 end
  describe "PUT #update" do
    context "with valid params" do
      it "Notifies unathouraized user save" do
        topic=Topic.create(title: 'Anything')
        patch :update, params: {id: topic.to_param}
        expect(response.status).to eq(401)
      end
    end
  end
  #flash message cases
  describe "POST #create" do
    context "with valid params" do
      it "Notifies a flash save" do
        topic=Topic.create(title: 'Anything')
        post :create, params: {id: topic.to_param}
        expect(:notice).should_not be_nil
      end
    end
  end
  describe "PUT #update" do
    context "with valid params" do
      it "Notifies flash message save" do
        topic=Topic.create(title: 'Anything')
        patch :update, params: {id: topic.to_param}
        expect(:notice).should_not be_nil
      end
    end
  end
  describe "DELETE #destroy" do
    it "destroys the requested topic" do
      @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("kishore:kishore")
      topic = Topic.create(title: 'Anything')
      expect {
        delete :destroy, params: {id: topic.to_param}
      }.to change{Topic.count}.by(-1)
      expect(:notice).should_not be_nil
    end
    end
  end