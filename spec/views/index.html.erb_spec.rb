require "spec_helper"
RSpec.describe "article/index", type: :view do
  it "displays all the articles" do
    assign(:Articles, [
        stub_model(articles, :name => "slicer"),
        stub_model(Widget, :name => "dicer")
    ])

    render

    rendered.should contain("slicer")
    rendered.should contain("dicer")
  end
end