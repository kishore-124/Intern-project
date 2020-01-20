require "spec_helper"
RSpec.describe "article/index", type: :view do
  it "displays all the articles" do
    visit root_path
    expect(page).to have_link("New Article")
  end
end