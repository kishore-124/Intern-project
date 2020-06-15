require 'rails_helper'

RSpec.describe "topics/edit", type: :view do
  before(:each) do
    @topic = assign(:topic, Topic.create!(
      :title => "MyString"
    ))
  end


end
