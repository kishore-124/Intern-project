require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:topics) }
  it { should have_many(:posts) }
  it { should have_many(:user_comment_ratings) }
  it { should have_many(:comment_review) }
  it { should have_and_belong_to_many(:post_reader) }
end
