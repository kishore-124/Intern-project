require 'rails_helper'
RSpec.describe "topics/index", type: :view do
  before(:each) do
    assign(:topics, [
      Topic.create!(
        :title => "Title"
      ),
      Topic.create!(
        :title => "Title"
      )
    ])
  end


end
