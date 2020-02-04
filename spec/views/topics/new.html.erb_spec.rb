require 'rails_helper'

RSpec.describe "topics/new", type: :view do
  before(:each) do
    assign(:topic, Topic.new(
      :title => "MyString"
    ))
  end

  it "renders new topic form" do
    render

    assert_select "form[action=?][method=?]", topics_path, "post" do

      assert_select "input[name=?]", "topic[title]"
    end
  end
  describe "GET #new" do


    it "render customer partial" do
      visit "/"
      expect(page).to have_content "Title can't be blank"
    end
  end

end
