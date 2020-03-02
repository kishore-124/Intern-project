require 'rails_helper'

RSpec.describe UserCommentRating, type: :model do
  it { should belong_to(:comment) }
  it { should belong_to(:user) }
end
