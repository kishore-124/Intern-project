require 'rails_helper'

RSpec.describe "tags/index", type: :view do
  before(:each) do
    assign(:tags, [
      Tag.create!(
        :name => "Name"
      ),
      Tag.create!(
        :name => "Name"
      )
    ])
  end


end
