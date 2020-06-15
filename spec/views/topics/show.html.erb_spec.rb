require 'rails_helper'
RSpec.describe "topics/show", type: :view do
  before(:each) do
    @topic = assign(:topic, Topic.create!(
      :title => "Title"
    ))
  end

end
