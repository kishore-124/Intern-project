require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:topics) }
  it { should have_many(:posts) }
  it { should have_many(:user_comment_ratings) }
  it { should have_many(:reviewers) }
end
